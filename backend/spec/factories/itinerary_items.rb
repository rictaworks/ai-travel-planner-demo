FactoryBot.define do
  factory :itinerary_item do
    association :itinerary_day
    association :spot
    sequence_order  { 0 }
    time_slot_start { "morning" }
    time_slot_end   { "morning" }
    cost            { 1000 }
  end
end
