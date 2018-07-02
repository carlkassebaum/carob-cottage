require 'rails_helper'

RSpec.describe BookingController, type: :routing do
    it 'routes get /administration/booking_manager to booking#index' do
        expect(get: "/administration/booking_manager").to route_to( controller: "booking", action: "index")        
    end
end
