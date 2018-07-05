class CreatePriceRules < ActiveRecord::Migration[5.2]
  def change
    create_table :price_rules do |t|
      t.string :name
      t.integer :value
      t.string :period_type
      t.integer :min_people
      t.integer :max_people
      t.date :start_date
      t.date :end_date
      t.integer :min_stay_duration
      t.integer :max_stay_duration
      t.text :description

      t.timestamps
    end
  end
end
