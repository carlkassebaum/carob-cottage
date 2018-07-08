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
    
    it "routes get '/booking/new' to booking#new" do
        expect(get: "/booking/new").to route_to( controller: "booking", action: "new")            
    end
    
    it "routes post '/booking' to booking#create" do
        expect(post: "/booking").to route_to( controller: "booking", action: "create")         
    end
    
    it "routes delete '/booking/id' to booking#destroy" do
        expect(delete: "/booking/1").to route_to( controller: "booking", action: "destroy", id: "1")               
    end
    
    it "routes get '/reservation' to booking#new_customer_booking" do
        expect(get: "/reservation").to route_to( controller: "booking", action: "new_customer_booking") 
    end
    
    it "routes post '/reservation' to booking#create_customer_booking" do
        expect(post: "/reservation").to route_to( controller: "booking", action: "create_customer_booking")         
    end
    
    it "routes get '/reservation/calendar' to booking#render_customer_reservation_calendar" do
        expect(get: "/reservation/calendar").to route_to(controller: "booking", action: "render_customer_reservation_calendar")
    end
end
