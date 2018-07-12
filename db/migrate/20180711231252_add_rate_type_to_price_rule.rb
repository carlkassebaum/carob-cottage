class AddRateTypeToPriceRule < ActiveRecord::Migration[5.2]
  def change
    add_column :price_rules, :rate_type, :string
  end
end
