class ChangeStartAndEndDateFormatInPriceRule < ActiveRecord::Migration[5.2]
  def change
    change_column :price_rules, :start_date, :string
    change_column :price_rules, :end_date, :string
  end
end
