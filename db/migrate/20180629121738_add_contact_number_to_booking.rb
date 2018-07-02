class AddContactNumberToBooking < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :contact_number, :string
  end
end
