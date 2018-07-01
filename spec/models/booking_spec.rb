require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe "bookings_within" do
    before :each do 
      @booking_1 = FactoryBot.create(:booking, name: "test_1", arrival_date: "20-1-2018", departure_date: "25-1-2018")
      @booking_2 = FactoryBot.create(:booking, name: "test_2", arrival_date: "31-1-2017", departure_date: "5-1-2018")
      @booking_3 = FactoryBot.create(:booking, name: "test_3", arrival_date: "15-5-2017", departure_date: "25-5-2017")
      @booking_4 = FactoryBot.create(:booking, name: "test_4", arrival_date: "29-5-2018", departure_date: "3-6-2018")
      @booking_5 = FactoryBot.create(:booking, name: "test_5", arrival_date: "1-8-2019",  departure_date: "2-10-2019")
      @booking_6 = FactoryBot.create(:booking, name: "test_6", arrival_date: "5-3-2018",  departure_date: "10-3-2018")
    end
    
    it "returns bookings with-in the given date range but ignores those beyond the date range" do
      date_range  = Date.new(2018,1,1)..Date.new(2018,12,31)
      test_result = Booking.bookings_within(date_range)
      expect(test_result).to eq([@booking_1, @booking_4, @booking_6, @booking_2])
    end
  end
  
  describe "attributes" do
    it "has a name attribute" do
      expect(FactoryBot.build(:booking)).to respond_to(:name)
    end
    
    it "has a postcode attribute" do
      expect(FactoryBot.build(:booking)).to respond_to(:postcode)        
    end
    
    it "has a country attribute" do
      expect(FactoryBot.build(:booking)).to respond_to(:country)        
    end
    
    it "has a contact_number attribute" do
      expect(FactoryBot.build(:booking)).to respond_to(:contact_number)        
    end
    
    it "has an email address attribute" do
      expect(FactoryBot.build(:booking)).to respond_to(:email_address)
    end
    
    it "has a number_of_people attribute" do
      expect(FactoryBot.build(:booking)).to respond_to(:number_of_people)        
    end
    
    it "has an estimated_arrival_time attribute" do
      expect(FactoryBot.build(:booking)).to respond_to(:estimated_arrival_time)        
    end

    it "has a preferred_payment_method attribute" do
      expect(FactoryBot.build(:booking)).to respond_to(:preferred_payment_method)        
    end
    
    it "has an arrival_date attribute" do
      expect(FactoryBot.build(:booking)).to respond_to(:arrival_date)        
    end
    
    it "has a departure_date attribute" do
      expect(FactoryBot.build(:booking)).to respond_to(:departure_date)        
    end    
    
    it "has a cost attribute" do
      expect(FactoryBot.build(:booking)).to respond_to(:cost)        
    end
    
    it "has a status attribute" do
      expect(FactoryBot.build(:booking)).to respond_to(:status)      
    end
  end 
end
