class Booking < ApplicationRecord
    #Get the bookings with date attributes between the date range for the arrival and departure dates
    def self.bookings_within(date_range)
        arrivals   = Booking.where(:arrival_date => date_range)
        departures = Booking.where(:departure_date => date_range)
        (arrivals + departures).uniq
    end
end
