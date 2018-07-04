require 'rails_helper'

RSpec.describe BookingController, type: :routing do
    it 'routes get /administration/booking_manager to booking#index' do
        expect(get: "/administration/booking_manager").to route_to( controller: "booking", action: "index")        
    end
    
    it "routes get '/booking/:id' to booking#show" do
        expect(get: "/booking/1").to route_to( controller: "booking", action: "show", id: "1")
    end
    
    it "routes get '/booking/:id/edit' to booking#edit" do
        expect(get: "/booking/1/edit").to route_to( controller: "booking", action: "edit", id: "1")        
    end
    
    it "routes put '/booking/:id' to booking#update" do 
        expect(put: "/booking/1").to route_to( controller: "booking", action: "update", id: "1")          
    end
end
