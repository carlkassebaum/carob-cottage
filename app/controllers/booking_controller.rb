class BookingController < ApplicationController
    def index
        @calendar_options={header_class: "full_reservation_calendar_headers"}
        @calendar_year = Date.today.year
    end
end
