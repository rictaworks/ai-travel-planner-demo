class ItineraryDay < ApplicationRecord
  belongs_to :itinerary
  has_many :itinerary_items, dependent: :destroy

  validates :day_number, numericality: { greater_than: 0 }
end
