class Region < ApplicationRecord
  has_many :spots, dependent: :restrict_with_error

  validates :name, presence: true
end
