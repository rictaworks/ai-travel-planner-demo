class ItinerariesController < ApplicationController
  before_action :set_itinerary, only: [:show]

  # POST /itineraries
  def create
    if honeypot_triggered?
      Rails.logger.warn("[ItinerariesController#create] Honeypot triggered. Request discarded.")
      render json: { error: "invalid_request" }, status: :unprocessable_entity
      return
    end

    session_id = current_session_id
    Rails.logger.info("[ItinerariesController#create] session_id=#{session_id}")

    service = ItineraryGeneratorService.new(
      trip_days:        itinerary_params[:trip_days],
      budget_total:     itinerary_params[:budget_total],
      preferences:      itinerary_params[:preferences] || [],
      expected_weather: itinerary_params[:expected_weather],
      owner_session_id: session_id
    )

    result = service.generate

    if result[:error].present?
      Rails.logger.warn("[ItinerariesController#create] Generation failed: #{result[:error]}")
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      itinerary = result[:itinerary]
      render json: itinerary_response(itinerary, result[:fallback], result[:fallback_message]),
             status: :created
    end
  rescue StandardError => e
    Rails.logger.error("[ItinerariesController#create] Unexpected error: #{e.class} - #{e.message}\n#{e.backtrace.first(5).join("\n")}")
    render json: { error: "internal_server_error" }, status: :internal_server_error
  end

  # GET /itineraries/:id
  def show
    render json: itinerary_response(@itinerary, false, nil), status: :ok
  end

  private

  def set_itinerary
    session_id = current_session_id
    @itinerary = Itinerary.owned_by(session_id).find_by(id: params[:id])

    unless @itinerary
      Rails.logger.warn("[ItinerariesController#show] Itinerary not found or session mismatch. id=#{params[:id]}")
      render json: { error: "not_found" }, status: :not_found
    end
  end

  def itinerary_params
    params.require(:itinerary).permit(
      :trip_days,
      :budget_total,
      :expected_weather,
      :honeypot,
      preferences: []
    )
  end

  def honeypot_triggered?
    itinerary_params[:honeypot].present?
  end

  def itinerary_response(itinerary, fallback, fallback_message)
    days = itinerary.itinerary_days.includes(itinerary_items: :spot).order(:day_number).map do |day|
      items = day.itinerary_items.includes(:spot).order(:sequence_order).map do |item|
        {
          id:              item.id,
          spot_id:         item.spot_id,
          spot_name:       item.spot.name,
          category:        item.spot.category,
          time_slot_start: item.time_slot_start,
          time_slot_end:   item.time_slot_end,
          cost:            item.cost,
          duration_min:    item.spot.duration_min
        }
      end

      {
        id:         day.id,
        day_number: day.day_number,
        items:      items
      }
    end

    response = {
      id:               itinerary.id,
      trip_days:        itinerary.trip_days,
      budget_total:     itinerary.budget_total,
      expected_weather: itinerary.expected_weather,
      status:           itinerary.status,
      created_at:       itinerary.created_at,
      days:             days
    }

    response[:fallback]         = fallback         if fallback
    response[:fallback_message] = fallback_message if fallback_message.present?

    response
  end
end
