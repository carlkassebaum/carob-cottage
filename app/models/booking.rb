class Booking < ApplicationRecord
    validate :unique_dates
    
    #Get the bookings with date attributes between the date range for the arrival and departure dates
    def self.bookings_within(date_range)
        arrivals   = Booking.where(:arrival_date => date_range)
        departures = Booking.where(:departure_date => date_range)
        (arrivals + departures).uniq
    end
    
    def self.next_after_date(date)
        bookings = Booking.where("arrival_date > ?", date)
        return bookings.length == 0 ? nil : bookings[0]
    end
    
    private
    
    def unique_dates
        begin
            date_range = (self.arrival_date.tomorrow)..(self.departure_date.yesterday)
            overlapping=Booking.bookings_within(date_range) - [self]
            if overlapping.length > 0
                errors.add(:overlapping_dates, "Overlapping arrival/departure dates given.")                
            end
        rescue
            errors.add(:dates, "Invalid date given.")  
        end
    end
end
