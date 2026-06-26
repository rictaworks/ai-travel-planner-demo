class CreateItineraryItems < ActiveRecord::Migration[8.1]
  def change
    create_table :itinerary_items do |t|
      t.references :itinerary_day, null: false, foreign_key: true
      t.references :spot, null: false, foreign_key: true
      t.integer :sequence_order
      t.string :time_slot_start
      t.string :time_slot_end
      t.integer :cost

      t.timestamps
    end
  end
end
