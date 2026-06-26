namespace :db do
  desc "Reset itinerary tables (itinerary_items, itinerary_days, itineraries)"
  task reset_itineraries: :environment do
    Rails.logger.info("[rake db:reset_itineraries] Starting itinerary table reset...")
    ItineraryItem.delete_all
    ItineraryDay.delete_all
    Itinerary.delete_all
    Rails.logger.info("[rake db:reset_itineraries] Reset complete.")
    puts "Itinerary tables have been reset."
  end
end
