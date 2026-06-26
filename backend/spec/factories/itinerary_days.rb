FactoryBot.define do
  factory :itinerary_day do
    association :itinerary
    day_number { 1 }
  end
end
