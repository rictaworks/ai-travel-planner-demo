class ItineraryItem < ApplicationRecord
  belongs_to :itinerary_day
  belongs_to :spot

  validates :sequence_order, numericality: { greater_than_or_equal_to: 0 }
  validates :cost, numericality: { greater_than_or_equal_to: 0 }
end
