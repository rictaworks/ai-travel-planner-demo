class Spot < ApplicationRecord
  belongs_to :region
  has_many :itinerary_items, dependent: :restrict_with_error

  CATEGORIES = %w[nature gourmet historical shopping activity relax].freeze
  INDOOR_OUTDOOR_OPTIONS = %w[indoor outdoor either].freeze

  validates :name, presence: true
  validates :category, inclusion: { in: CATEGORIES }
  validates :indoor_outdoor, inclusion: { in: INDOOR_OUTDOOR_OPTIONS }
  validates :cost, numericality: { greater_than_or_equal_to: 0 }
  validates :duration_min, numericality: { greater_than: 0 }
end
