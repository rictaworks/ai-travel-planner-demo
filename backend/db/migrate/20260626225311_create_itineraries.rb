class CreateItineraries < ActiveRecord::Migration[8.1]
  def change
    create_table :itineraries do |t|
      t.string :owner_session_id
      t.integer :trip_days
      t.integer :budget_total
      t.text :preference_json
      t.string :expected_weather
      t.string :status, default: "draft", null: false

      t.timestamps
    end
  end
end
