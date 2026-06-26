class CreateItineraryDays < ActiveRecord::Migration[8.1]
  def change
    create_table :itinerary_days do |t|
      t.references :itinerary, null: false, foreign_key: true
      t.integer :day_number

      t.timestamps
    end
  end
end
