class CreateSpots < ActiveRecord::Migration[8.1]
  def change
    create_table :spots do |t|
      t.references :region, null: false, foreign_key: true
      t.string :name
      t.string :category
      t.integer :cost
      t.integer :duration_min
      t.string :indoor_outdoor
      t.text :description

      t.timestamps
    end
  end
end
