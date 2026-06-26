# Itinerary generation service implementing rule-based logic as per spec.
#
# Usage:
#   service = ItineraryGeneratorService.new(params)
#   result  = service.generate
#   # result is either:
#   #   { error: 'no_plan_available' }
#   # or
#   #   { itinerary: <Itinerary>, fallback: true/false, fallback_message: nil/"..." }
class ItineraryGeneratorService
  # Maximum minutes per day
  DAILY_CAPACITY_MINUTES = 480
  # Maximum spots per day
  DAILY_SPOT_LIMIT = 4
  # Outdoor-sensitive weather conditions
  OUTDOOR_EXCLUSION_WEATHER = %w[rainy snowy].freeze
  # Category to time slot mapping
  TIME_SLOT_MAP = {
    "nature"     => "morning",
    "historical" => "morning",
    "gourmet"    => "lunch",
    "shopping"   => "afternoon",
    "activity"   => "afternoon",
    "relax"      => "afternoon"
  }.freeze
  # Message shown when fallback selection is used
  FALLBACK_MESSAGE = "好みに完全一致するスポットがないため一部代替しています".freeze

  def initialize(params)
    @trip_days       = params[:trip_days].to_i
    @budget_total    = params[:budget_total].to_i
    @preferences     = Array(params[:preferences])
    @expected_weather = params[:expected_weather].to_s
    @owner_session_id = params[:owner_session_id].to_s
  end

  # Main entry point. Returns a result hash.
  def generate
    Rails.logger.info(
      "[ItineraryGeneratorService] Starting generation. " \
      "trip_days=#{@trip_days}, budget=#{@budget_total}, weather=#{@expected_weather}, " \
      "preferences=#{@preferences.inspect}"
    )

    candidates = weather_filtered_spots
    Rails.logger.info("[ItineraryGeneratorService] Candidates after weather filter: #{candidates.size}")

    scored = score_spots(candidates, @preferences)
    preferred = scored.select { |s| s[:preference_score] > 1 }

    use_fallback = @preferences.any? && preferred.empty?

    if use_fallback
      Rails.logger.info("[ItineraryGeneratorService] No preference-matched spots. Activating fallback.")
      scored = score_spots(candidates, [])
    end

    selected = greedy_select(scored)
    Rails.logger.info("[ItineraryGeneratorService] Selected spots: #{selected.map { |s| s[:spot].name }.inspect}")

    if selected.empty?
      Rails.logger.warn("[ItineraryGeneratorService] No spots could be selected within budget.")
      return { error: "no_plan_available" }
    end

    days = assign_to_days(selected)
    itinerary = persist_itinerary(days, use_fallback)

    result = { itinerary: itinerary, fallback: use_fallback, fallback_message: nil }
    result[:fallback_message] = FALLBACK_MESSAGE if use_fallback
    Rails.logger.info("[ItineraryGeneratorService] Generation complete. itinerary_id=#{itinerary.id}")
    result
  end

  private

  # Step 1: Filter spots by weather condition.
  def weather_filtered_spots
    if OUTDOOR_EXCLUSION_WEATHER.include?(@expected_weather)
      Spot.where.not(indoor_outdoor: "outdoor")
    else
      Spot.all
    end
  end

  # Step 2: Score spots by preference priority.
  def score_spots(spots, preferences)
    pref_weight = build_preference_weights(preferences)

    spots.map do |spot|
      weight = pref_weight[spot.category]
      preference_score = weight || 1
      efficiency = spot.cost.positive? ? preference_score.to_f / spot.cost : Float::INFINITY

      {
        spot:             spot,
        preference_score: preference_score,
        efficiency:       efficiency
      }
    end
  end

  # Build a hash mapping category -> weight for the given preference list.
  # preferences is an ordered array like ["nature", "gourmet", ...]
  def build_preference_weights(preferences)
    return {} if preferences.empty?

    total = preferences.size
    preferences.each_with_index.each_with_object({}) do |(category, index), hash|
      hash[category] = total - index
    end
  end

  # Step 4: Greedy selection respecting budget, time, and count constraints.
  def greedy_select(scored_spots)
    max_count   = DAILY_SPOT_LIMIT * @trip_days
    max_minutes = DAILY_CAPACITY_MINUTES * @trip_days

    sorted = scored_spots.sort_by { |s| [-s[:efficiency], s[:spot].id] }

    selected      = []
    total_cost    = 0
    total_minutes = 0

    sorted.each do |entry|
      spot = entry[:spot]

      break if selected.size >= max_count

      next if total_cost + spot.cost > @budget_total
      next if total_minutes + spot.duration_min > max_minutes

      selected << entry
      total_cost    += spot.cost
      total_minutes += spot.duration_min
    end

    selected
  end

  # Step 6: Assign selected spots to days using round-robin with category-based time slots.
  def assign_to_days(selected_entries)
    days = Array.new(@trip_days) { [] }
    day_minutes = Array.new(@trip_days, 0)
    day_counts  = Array.new(@trip_days, 0)

    # Separate gourmet spots so lunch / dinner alternation can be applied.
    gourmet_entries = selected_entries.select { |e| e[:spot].category == "gourmet" }
    other_entries   = selected_entries.reject { |e| e[:spot].category == "gourmet" }

    # Assign non-gourmet spots round-robin.
    day_index = 0
    other_entries.each do |entry|
      spot = entry[:spot]
      target_day = find_available_day(day_index, days, day_minutes, day_counts, spot)
      next if target_day.nil?

      days[target_day] << build_day_item(spot, time_slot_for(spot.category, days[target_day]))
      day_minutes[target_day] += spot.duration_min
      day_counts[target_day]  += 1
      day_index = (target_day + 1) % @trip_days
    end

    # Assign gourmet spots, alternating between lunch and dinner.
    gourmet_index = 0
    day_index = 0
    gourmet_entries.each do |entry|
      spot = entry[:spot]
      target_day = find_available_day(day_index, days, day_minutes, day_counts, spot)
      next if target_day.nil?

      slot = gourmet_index.even? ? "lunch" : "dinner"
      days[target_day] << build_day_item(spot, slot)
      day_minutes[target_day] += spot.duration_min
      day_counts[target_day]  += 1
      day_index = (target_day + 1) % @trip_days
      gourmet_index += 1
    end

    days
  end

  # Find the first available day starting from start_day using round-robin.
  def find_available_day(start_day, days, day_minutes, day_counts, spot)
    @trip_days.times do |offset|
      idx = (start_day + offset) % @trip_days
      next if day_counts[idx] >= DAILY_SPOT_LIMIT
      next if day_minutes[idx] + spot.duration_min > DAILY_CAPACITY_MINUTES

      return idx
    end
    nil
  end

  # Build item hash for a day slot.
  def build_day_item(spot, slot)
    { spot: spot, time_slot: slot }
  end

  # Determine the time slot for a non-gourmet category.
  def time_slot_for(category, _existing_day_items)
    TIME_SLOT_MAP.fetch(category, "afternoon")
  end

  # Step 7: Persist itinerary and related records.
  def persist_itinerary(days, use_fallback)
    ActiveRecord::Base.transaction do
      itinerary = Itinerary.create!(
        owner_session_id: @owner_session_id,
        trip_days:        @trip_days,
        budget_total:     @budget_total,
        preference_json:  @preferences.to_json,
        expected_weather: @expected_weather,
        status:           "generated"
      )

      days.each_with_index do |items, day_index|
        day = ItineraryDay.create!(
          itinerary:  itinerary,
          day_number: day_index + 1
        )

        items.each_with_index do |item, seq|
          ItineraryItem.create!(
            itinerary_day:   day,
            spot:            item[:spot],
            sequence_order:  seq,
            time_slot_start: item[:time_slot],
            time_slot_end:   item[:time_slot],
            cost:            item[:spot].cost
          )
        end
      end

      itinerary
    end
  end
end
