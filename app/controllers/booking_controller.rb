class BookingController < ApplicationController
    def index
        @calendar_options={header_class: "full_reservation_calendar_headers", body_class: "full_reservation_calendar_body"}
        @calendar_year = Date.today.year
        
        date_range = Date.new(@calendar_year,1,1)..Date.new(@calendar_year,12,31)
        bookings   = Booking.bookings_within(date_range)
        
        @year_reservations = {}
        
        #Build the year reservations calendar
        bookings.each do | booking |
            date_range = (booking.arrival_date..booking.departure_date).to_a
            date_range.map.with_index do |date, index|
                next if date.year != @calendar_year
                current_month = Date::MONTHNAMES[date.mon]
                @year_reservations[current_month] = {} if @year_reservations[current_month].nil?
                if index == 0
                    type = "arrive"
                elsif index == date_range.length - 1
                    type = "depart"
                else
                    type = "stay"
                end
                @year_reservations[current_month][date.mday] = {} if @year_reservations[current_month][date.mday].nil?
                @year_reservations[current_month][date.mday][type] = {id: booking, status: booking.status}
            end
        end
    end
end
