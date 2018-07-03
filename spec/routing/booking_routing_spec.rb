require 'rails_helper'

RSpec.describe BookingController, type: :routing do
    it 'routes get /administration/booking_manager to booking#index' do
        expect(get: "/administration/booking_manager").to route_to( controller: "booking", action: "index")        
    end
    
    it "routes get '/administration/booking_manager/booking/:id' to booking#show" do
        expect(get: "/administration/booking_manager/booking/1").to route_to( controller: "booking", action: "show", id: "1")            
    end
end
