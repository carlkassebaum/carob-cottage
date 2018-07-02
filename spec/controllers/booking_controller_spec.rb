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
        
        describe "retrieves and transforms booking data" do
            before(:each) do
                @booking_1 = FactoryBot.create(:booking, name: "test_1", arrival_date: "20-1-2018",  departure_date: "25-1-2018")#DONE
                @booking_2 = FactoryBot.create(:booking, name: "test_2", arrival_date: "31-12-2017", departure_date: "5-1-2018" )#DONE
                @booking_3 = FactoryBot.create(:booking, name: "test_3", arrival_date: "22-5-2017",  departure_date: "25-5-2017")
                @booking_4 = FactoryBot.create(:booking, name: "test_4", arrival_date: "30-5-2018",  departure_date: "1-6-2018" )
                @booking_5 = FactoryBot.create(:booking, name: "test_5", arrival_date: "1-8-2019",   departure_date: "2-10-2019")
                @booking_6 = FactoryBot.create(:booking, name: "test_6", arrival_date: "5-3-2018",   departure_date: "8-3-2018")                
            end
            
            it "sets @year_reservations to a transformed version of the bookings" do
                Timecop.travel(Time.local(2018, 5, 15, 10, 0, 0))                
                januray_dates = 
                {
                    20 => {id: @booking_1, type: "arrive"},
                    21 => {id: @booking_1, type: "stay"  },
                    22 => {id: @booking_1, type: "stay"  },
                    23 => {id: @booking_1, type: "stay"  },
                    24 => {id: @booking_1, type: "stay"  },
                    25 => {id: @booking_1, type: "depart"},
                    1  => {id: @booking_2, type: "stay"},
                    2  => {id: @booking_2, type: "stay"  },
                    3  => {id: @booking_2, type: "stay"  },
                    4  => {id: @booking_2, type: "stay"  },
                    5  => {id: @booking_2, type: "depart"}                    
                }
                march_dates = 
                {
                    5 => {id: @booking_6, type: "arrive"},
                    6 => {id: @booking_6, type: "stay"  },
                    7 => {id: @booking_6, type: "stay"  },
                    8 => {id: @booking_6, type: "depart"},                    
                }
                may_dates = 
                {
                    30 => {id: @booking_4, type: "arrive"},
                    31 => {id: @booking_4, type: "stay"  }
                }
                june_dates = 
                {
                    1 => {id: @booking_4, type: "depart"}
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
