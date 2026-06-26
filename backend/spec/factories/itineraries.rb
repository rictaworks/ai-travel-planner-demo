FactoryBot.define do
  factory :itinerary do
    sequence(:owner_session_id) { |n| "session-#{n}" }
    trip_days        { 1 }
    budget_total     { 10000 }
    preference_json  { [].to_json }
    expected_weather { "sunny" }
    status           { "generated" }
  end
end
