class Itinerary < ApplicationRecord
  has_many :itinerary_days, dependent: :destroy
  has_many :itinerary_items, through: :itinerary_days

  STATUSES = %w[draft generating generated failed reset].freeze
  WEATHER_OPTIONS = %w[sunny cloudy rainy snowy].freeze

  validates :owner_session_id, presence: true
  validates :trip_days, numericality: { greater_than: 0, less_than_or_equal_to: 3 }
  validates :budget_total, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: STATUSES }
  validates :expected_weather, inclusion: { in: WEATHER_OPTIONS }

  scope :owned_by, ->(session_id) { where(owner_session_id: session_id) }
end
