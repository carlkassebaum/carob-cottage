require 'rails_helper'

RSpec.describe BookingController, type: :controller do
    describe "index" do
        it "sets @month_calendar options to the correct options" do
            options = {header_class: "full_reservation_calendar_headers"}
            get :index
            expect(assigns(:calendar_options)).to eq(options)
        end
        
        it "sets @calendar_year to the current year" do
            Timecop.travel(Time.local(2010, 5, 15, 10, 0, 0))
            get :index
            expect(assigns(:calendar_year)).to eq(2010)             
        end
    end
end
