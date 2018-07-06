# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

FactoryBot.create(  :administrator,
                    name: "bob",
                    email_address: "bob@outlook.com",
                    password: "foo_bar",
                    password_confirmation: "foo_bar")

Booking.create(name: "test_1", arrival_date: "20-1-2018", departure_date: "26-1-2018", status: "reserved")
Booking.create(name: "test_2", arrival_date: "26-1-2018", departure_date: "2-2-2018",  status: "reserved")
Booking.create(name: "test_3", arrival_date: "2-2-2018",  departure_date: "8-2-2018",  status: "booked")

PriceRule.create(name: "Base Rate", value: 185, period_type: "per_night", min_people: 1, max_people: 2, min_stay_duration: 2, max_stay_duration: 6, 
    description: "A base rate of $185 per night applies for 1 to 2 people.")
PriceRule.create(name: "Additonal People", 
    value: 30, period_type: "per_night", min_people: 3, 
    description: "Additonal people are charged at $30 per night.")
PriceRule.create(name: "Easter", value: 205, period_type: "per_night", min_people: 1, max_people: 2, start_date: "19-4", end_date: "22-4",
    description: "Stays during the Easter period are charged at $205 per night.")
PriceRule.create(name: "Cleaning", value: 10, period_type: "fixed",
    description: "Stays during the Easter period are charged at $205 per night.")
PriceRule.create(name: "7 night stay", value: 170, period_type: "per_night", min_people: 1, max_people: 2,
    min_stay_duration: 7, max_stay_duration: 7, description: "Stays for 7 nights are charged at $170 per night.")
PriceRule.create(name: "Stays longer than 7 nights", value: 165, period_type: "per_night", min_people: 1, max_people: 2,
    min_stay_duration: 8, description: "Stays for 8 or more nights are charged at $165 per night.")