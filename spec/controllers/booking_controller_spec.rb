require 'rails_helper'

RSpec.describe BookingController, type: :controller do
    describe "index" do
        describe "not logged in" do
            it "redirects to the login page" do
                get :index
                expect(flash[:alert]).to eq("You must be logged in to view that content")
                expect(response).to redirect_to(administration_login_path)
            end
        end
        
        describe "logged in" do
            before(:each) do
                session[:logged_in] = true
            end
            
            it "sets @month_calendar options to the correct options" do
                options = {header_class: "full_reservation_calendar_headers", body_class: "full_reservation_calendar_body"}
                get :index
                expect(assigns(:calendar_options)).to eq(options)
            end
            
            describe "@calenday_year" do
                it "sets @calendar_year to the current year if params[:year] is not given" do
                    Timecop.travel(Time.local(2010, 5, 15, 10, 0, 0))
                    get :index
                    expect(assigns(:calendar_year)).to eq(2010)             
                end
                
                it "sets @calendar_year to params[:year] if it is given" do
                    Timecop.travel(Time.local(2010, 5, 15, 10, 0, 0))
                    get :index, params: {year: "2012"}
                    expect(assigns(:calendar_year)).to eq(2012)
                end
                
                it "does not set @calendar_year to params[:year] if the year given is invalid" do
                    Timecop.travel(Time.local(2010, 5, 15, 10, 0, 0))
                    get :index, params: {year: "AF2012"}
                    expect(assigns(:calendar_year)).to eq(2010)                
                end
                
                it "does not set @calendar_year to params[:year] if the year given is negative" do
                    Timecop.travel(Time.local(2010, 5, 15, 10, 0, 0))
                    get :index, params: {year: "-0001"}
                    expect(assigns(:calendar_year)).to eq(2010)                
                end            
            end
            
            describe "retrieves and transforms booking data" do
                before(:each) do
                    @booking_1 = FactoryBot.create(:booking, name: "test_1", arrival_date: "20-1-2018",  departure_date: "25-1-2018", status: "reserved")
                    @booking_2 = FactoryBot.create(:booking, name: "test_2", arrival_date: "31-12-2017", departure_date: "5-1-2018",  status: "reserved")
                    @booking_3 = FactoryBot.create(:booking, name: "test_3", arrival_date: "22-5-2017",  departure_date: "25-5-2017", status: "booked"  )
                    @booking_4 = FactoryBot.create(:booking, name: "test_4", arrival_date: "30-5-2018",  departure_date: "1-6-2018",  status: "booked"  )
                    @booking_5 = FactoryBot.create(:booking, name: "test_5", arrival_date: "1-8-2019",   departure_date: "2-10-2019", status: "reserved")
                    @booking_6 = FactoryBot.create(:booking, name: "test_6", arrival_date: "5-3-2018",   departure_date: "8-3-2018",  status: "reserved")
                    @booking_7 = FactoryBot.create(:booking, name: "test_7", arrival_date: "25-1-2018",  departure_date: "27-1-2018", status: "booked")                
                end
                
                it "sets @year_reservations to a transformed version of the bookings" do
                    Timecop.travel(Time.local(2018, 5, 15, 10, 0, 0))                
                    januray_dates = 
                    {
                        20 => {"arrive" => {id: @booking_1, status: "reserved"}},
                        21 => {"stay"   => {id: @booking_1, status: "reserved"}},
                        22 => {"stay"   => {id: @booking_1, status: "reserved"}},
                        23 => {"stay"   => {id: @booking_1, status: "reserved"}},
                        24 => {"stay"   => {id: @booking_1, status: "reserved"}},
                        25 => {"depart" => {id: @booking_1, status: "reserved"},
                               "arrive" => {id: @booking_7, status: "booked"  }},
                        26 => {"stay"   => {id: @booking_7, status: "booked"  }},
                        27 => {"depart" => {id: @booking_7, status: "booked"  }},
                        1  => {"stay"   => {id: @booking_2, status: "reserved"}},
                        2  => {"stay"   => {id: @booking_2, status: "reserved"}},
                        3  => {"stay"   => {id: @booking_2, status: "reserved"}},
                        4  => {"stay"   => {id: @booking_2, status: "reserved"}},
                        5  => {"depart" => {id: @booking_2, status: "reserved"}}                    
                    }
                    march_dates = 
                    {
                        5 => {"arrive" => {id: @booking_6, status: "reserved"}},
                        6 => {"stay" =>   {id: @booking_6, status: "reserved"}},
                        7 => {"stay" =>   {id: @booking_6, status: "reserved"}},
                        8 => {"depart" => {id: @booking_6, status: "reserved"}},
                    }
                    may_dates = 
                    {
                        30 => {"arrive" => {id: @booking_4, status: "booked"}},
                        31 => {"stay"   => {id: @booking_4, status: "booked"}}
                    }
                    june_dates = 
                    {
                        1 => {"depart" => {id: @booking_4, status: "booked"}}
                    }
                    
                    expected_value = 
                    {
                        "January" => januray_dates,
                        "March"   => march_dates, 
                        "May"     => may_dates,
                        "June"    => june_dates
                    }
                    
                    get :index
                    expect(assigns(:year_reservations)).to eq(expected_value)
                end
            end
        end
    end
    
    describe "show" do
        describe "logged out" do
            it "sets flash[:alert] to a warning" do
                @booking_1 = FactoryBot.create(:booking, id: 1, name: "test_1", arrival_date: "20-1-2018",  departure_date: "25-1-2018", status: "reserved") 
                get :show, xhr: true , params: {id: 1}                
                expect(flash[:alert]).to eq("You must be logged in to view that content")
            end
        end
        
        describe "logged in" do
            before :each do
                session[:logged_in] = true
                @booking_1 = FactoryBot.create(:booking, id: 1, name: "test_1", arrival_date: "20-1-2018",  departure_date: "25-1-2018", status: "reserved")                
            end
            it "sets @booking to the booking corresponding to the id given" do
                get :show, xhr: true , params: {id: 1}
                expect(assigns(:booking)).to eq(@booking_1)
            end
            
            it "sets flash[:alert] if there is no booking with a matching id" do
                get :show, xhr: true, params: {id: 2}
                expect(flash[:alert]).to eq("There is no matching booking with an id of 2.")
            end
        end 
    end
    
    describe "edit" do
        describe "logged out" do
            it "sets flash[:alert] to a warning" do
                @booking_1 = FactoryBot.create(:booking, id: 1, name: "test_1", arrival_date: "20-1-2018",  departure_date: "25-1-2018", status: "reserved") 
                get :edit, xhr: true , params: {id: 1}                
                expect(flash[:alert]).to eq("You must be logged in to view that content")
            end     
        end
        
        describe "logged in" do
            
            before :each do
                @booking_1 = FactoryBot.create(:booking, id: 1, name: "test_1", arrival_date: "20-1-2018",  departure_date: "25-1-2018", status: "reserved")
                session[:logged_in] = true
            end
            
            it "sets @booking to the booking corresponding to the id given" do
                get :edit, xhr: true , params: {id: 1}
                expect(assigns(:booking)).to eq(@booking_1)
            end
            
            it "sets flash[:alert] if there is no booking with a matching id" do
                get :edit, xhr: true, params: {id: 2}
                expect(flash[:alert]).to eq("There is no matching booking with an id of 2.")
            end             
        end
    end
    
    describe "update" do
       describe "not logged in" do
            it "redirects to the login page" do
                booking_1 = FactoryBot.create(:booking, id: 1, name: "test_1", arrival_date: "20-1-2018",  departure_date: "25-1-2018", status: "reserved")
                new_values = {name: "test_7", arrival_date: "21-1-2018", departure_date: "24-1-2018", status: "booked"}
                put :update, params: {id: 1, booking: new_values}
                expect(flash[:alert]).to eq("You must be logged in to view that content")
                expect(response).to redirect_to(administration_login_path)
            end
        end
        
        describe "logged in" do
            before :each do
                @booking_1 = FactoryBot.create(:booking, id: 1, name: "test_1", arrival_date: "20-1-2018",  departure_date: "25-1-2018", status: "reserved")
                session[:logged_in] = true
            end
            
            after :each do
                expect(:response).to redirect_to(administration_booking_manager_path)
            end           
            
            describe "valid params" do
                it "updates an existing booking with the new parameters" do
                    new_values = {name: "test_7", arrival_date: "21-1-2018", departure_date: "24-1-2018", status: "booked"}
                    put :update, params: {id: 1, booking: new_values}
                    booking = Booking.find_by(id: 1)
                    expect(booking.name).to eq(new_values[:name])
                    expect(booking.arrival_date).to eq(Date.parse(new_values[:arrival_date]))  
                    expect(booking.departure_date).to eq(Date.parse(new_values[:departure_date]))
                    expect(booking.status).to eq(new_values[:status])
                end
                
                it "leaves other values untouched" do
                    new_values = {name: "test_7", arrival_date: "21-1-2018", departure_date: "24-1-2018"}
                    put :update, params: {id: @booking_1.id, booking: new_values}
                    booking = Booking.find_by(id: @booking_1.id)
                    expect(booking.name).to eq(new_values[:name])
                    expect(booking.arrival_date).to eq(Date.parse(new_values[:arrival_date]))  
                    expect(booking.departure_date).to eq(Date.parse(new_values[:departure_date]))
                    expect(booking.status).to eq(@booking_1.status)            
                end 
                
                it "assigns flash[:notification] to reflect a successful update" do
                    new_values = {name: "test_7", arrival_date: "21-1-2018", departure_date: "24-1-2018"}
                    put :update, params: {id: @booking_1.id, booking: new_values}
                    expect(flash[:notification]).to eq("Booking #{@booking_1.id} sucessfully updated")
                end
            end
            
            describe "invalid dates" do
                it "sets flash[:alert] and redirects when an invalid arrival date is given" do
                    new_values = {name: "test_7", arrival_date: "junk", departure_date: "24-1-2018", status: "reserved"}
                    put :update, params: {id: @booking_1.id, booking: new_values}
                    expect(flash[:alert]).to eq("No changes made. Invalid arrival date given.")
                    expect(response).to redirect_to(administration_booking_manager_path)
                end
                
                it "sets flash[:alert] and redirects when an invalid arrival date is given" do
                    new_values = {name: "test_7", arrival_date: "24-1-2018", departure_date: "junk", status: "reserved"}
                    put :update, params: {id: @booking_1.id, booking: new_values}
                    expect(flash[:alert]).to eq("No changes made. Invalid departure date given.")
                    expect(response).to redirect_to(administration_booking_manager_path)                
                end
                
                it "sets flash[:alert] and redirects when no arrival date is given" do
                    new_values = {name: "test_7", arrival_date: "", departure_date: "24-1-2018", status: "reserved"}
                    put :update, params: {id: @booking_1.id, booking: new_values}
                    expect(flash[:alert]).to eq("No changes made. Invalid arrival date given.")
                    expect(response).to redirect_to(administration_booking_manager_path)                
                end
                
                it "sets flash[:alert] and redirects when the departure dates is earlier than the arrival date" do
                    new_values = {name: "test_7", arrival_date: "26-1-2018", departure_date: "24-1-2018", status: "reserved"}  
                    put :update, params: {id: @booking_1.id, booking: new_values}
                    expect(flash[:alert]).to eq("No changes made. Invalid departure date given.")
                    expect(response).to redirect_to(administration_booking_manager_path)                
                end
            end
        end
    end
    
    describe "new" do
        describe "logged out" do
            it "sets flash[:alert] to a warning message" do
                get :new, xhr: true                
                expect(flash[:alert]).to eq("You must be logged in to view that content")                 
            end
        end
        
        describe "logged in" do
            it "assigns @booking to an empty booking" do
                session[:logged_in] = true
                get :new, xhr: true
                expect(assigns(:booking).to_json).to eq(FactoryBot.build(:booking, {}).to_json)
            end            
        end
    end
    
    describe "destroy" do
        describe "logged out" do
            it "redirects to the login page" do
                @booking_1 = FactoryBot.create(:booking, id: 1, name: "test_1", arrival_date: "20-1-2018",  departure_date: "25-1-2018", status: "reserved")
                delete :destroy, params: {id: @booking_1.id}
                expect(flash[:alert]).to eq("You must be logged in to view that content")
                expect(response).to redirect_to(administration_login_path)            
            end
        end
        
        describe "logged in" do
            before :each do
                @booking_1 = FactoryBot.create(:booking, id: 1, name: "test_1", arrival_date: "20-1-2018",  departure_date: "25-1-2018", status: "reserved") 
                session[:logged_in] = true
            end
            
            after(:each) do
                expect(:response).to redirect_to(administration_booking_manager_path)
            end        
            
            describe "valid delete" do
                it "removes the given booking from the database" do
                    delete :destroy, params: {id: @booking_1.id}
                    expect(Booking.all.length).to eq(0) 
                end
                
                it "sets flash[:notification] to a success message" do
                    delete :destroy, params: {id: @booking_1.id}
                    expect(flash[:notification]).to eq("Booking successfully deleted")
                end
            end
            
            describe "invalid delete" do
                it "sets flash[:alert] to a warning message when an invalid id is given" do
                    delete :destroy, params: {id: "junk"}
                    expect(flash[:alert]).to eq("Booking with id \"junk\" not found!")                
                end
                
                it "sets flash[:alert] to a warning message when an invalid id is given" do
                    delete :destroy, params: {id: ""}
                    expect(flash[:alert]).to eq("No Booking id given!")                
                end            
            end
        end
    end
    
    describe "create" do
        describe "logged out" do
            it "redirects to the login page" do
                new_values = {name: "test_7", arrival_date: "21-1-2018", departure_date: "24-1-2018", status: "reserved"}
                post :create, params: {booking: new_values}
                expect(flash[:alert]).to eq("You must be logged in to view that content")
                expect(response).to redirect_to(administration_login_path)            
            end
        end


        describe "logged in" do
            before :each do
                session[:logged_in] = true
            end
            
            after(:each) do
                expect(:response).to redirect_to(administration_booking_manager_path)
            end           
            
            describe "valid details" do
                it "assigns @booking to the corresponding parameters" do
                    new_values = {name: "test_7", arrival_date: "21-1-2018", departure_date: "24-1-2018", status: "reserved"}
                    post :create, params: {booking: new_values}
                    booking = Booking.find_by(name: "test_7")
                    expect(booking).not_to eq(nil)
                    expect(booking.arrival_date).to eq(Date.parse(new_values[:arrival_date]))
                    expect(booking.departure_date).to eq(Date.parse(new_values[:departure_date]))
                    expect(booking.status).to eq(new_values[:status])
                end
                
                it "assigns flash[:notification] to a corresponding message" do
                    new_values = {name: "test_7", arrival_date: "21-1-2018", departure_date: "24-1-2018", status: "reserved"}
                    post :create, params: {booking: new_values}
                    expect(flash[:notification]).to eq("New Booking succesfully created")
                    expect(response).to redirect_to(administration_booking_manager_path)
                end
            end
            
            describe "invalid dates" do
                it "sets flash[:alert] when an invalid arrival date is given" do
                    new_values = {name: "test_7", arrival_date: "junk", departure_date: "24-1-2018", status: "reserved"}
                    post :create, params: {booking: new_values}
                    expect(flash[:alert]).to eq("Booking not created. Invalid arrival date given.")
                end
                
                it "sets flash[:alert] and redirects when an invalid arrival date is given" do
                    new_values = {name: "test_7", arrival_date: "24-1-2018", departure_date: "junk", status: "reserved"}
                    post :create, params: {booking: new_values}
                    expect(flash[:alert]).to eq("Booking not created. Invalid departure date given.")          
                end
                
                it "sets flash[:alert] and redirects when no arrival date is given" do
                    new_values = {name: "test_7", arrival_date: "", departure_date: "24-1-2018", status: "reserved"}
                    post :create, params: {booking: new_values}
                    expect(flash[:alert]).to eq("Booking not created. Invalid arrival date given.")           
                end
                
                it "sets flash[:alert] and redirects when the departure dates is earlier than the arrival date" do
                    new_values = {name: "test_7", arrival_date: "26-1-2018", departure_date: "24-1-2018", status: "reserved"}  
                    post :create, params: {booking: new_values}
                    expect(flash[:alert]).to eq("Booking not created. Invalid departure date given.")            
                end
            end
        end
    end
end
