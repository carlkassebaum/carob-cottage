class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.string :name
      t.string :postcode
      t.string :country
      t.string :email_address
      t.integer :number_of_people
      t.string :estimated_arrival_time
      t.string :preferred_payment_method
      t.date :arrival_date
      t.date :departure_date

      t.timestamps
    end
  end
end
