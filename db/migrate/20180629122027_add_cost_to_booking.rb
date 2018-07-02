class AddCostToBooking < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :cost, :integer
  end
end
