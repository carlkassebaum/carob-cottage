require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe "bookings_within" do
    before :each do 
      @booking_1 = FactoryBot.create(:booking, name: "test_1", arrival_date: "20-1-2018", departure_date: "25-1-2018")
      @booking_2 = FactoryBot.create(:booking, name: "test_2", arrival_date: "31-1-2018", departure_date: "5-1-2018")
      @booking_3 = FactoryBot.create(:booking, name: "test_3", arrival_date: "15-5-2017", departure_date: "25-5-2017")
      @booking_4 = FactoryBot.create(:booking, name: "test_4", arrival_date: "29-5-2018", departure_date: "3-6-2018")
      @booking_5 = FactoryBot.create(:booking, name: "test_5", arrival_date: "1-8-2019",  departure_date: "2-10-2019")
      @booking_6 = FactoryBot.create(:booking, name: "test_6", arrival_date: "5-3-2018",  departure_date: "10-3-2018")
    end
    
    it "returns bookings with-in the given date range but ignores those beyond the date range" do
      date_range  = Date.new(2018,1,1)..Date.new(2018,12,31)
      test_result = Booking.bookings_within(date_range)
      
      expect(test_result.include? @booking_1).to eq(true)
      expect(test_result.include? @booking_2).to eq(true)
      expect(test_result.include? @booking_4).to eq(true)
      expect(test_result.include? @booking_6).to eq(true)      
      expect(test_result.include? @booking_3).to eq(false)
      expect(test_result.include? @booking_5).to eq(false)
      expect(test_result.length).to eq(4)
    end
  end
  
  describe "validation" do
    before :each do
      @booking_1 = FactoryBot.create(:booking, name: "test_1", arrival_date: "20-1-2018", departure_date: "25-1-2018")
      @booking_2 = FactoryBot.create(:booking, name: "test_2", arrival_date: "31-1-2018", departure_date: "5-1-2018")      
    end
    
    it "allows for bookings with the same departure date and arrival dates of other bookings to be stored" do
      booking = Booking.new(name: "test_3", arrival_date: "25-1-2018", departure_date: "31-1-2018")
      expect(booking.save).to eq(true)
    end
    
    describe "overlapping dates" do
      it "forces save to evaluate to false with overlapping dates" do
        booking = Booking.new(name: "test_3", arrival_date: "25-1-2018", departure_date: "1-2-2018")
        expect(booking.save).to eq(false)
      end
      
      it "adds invalid date messages to the error of the booking" do
        booking = Booking.new(name: "test_3", arrival_date: "25-1-2018", departure_date: "1-2-2018")
        booking.save
        expect(booking.errors[:overlapping_dates]).to eq(["Overlapping arrival/departure dates given."])
      end
      
      it "does not save the booking" do
        booking = Booking.new(name: "test_3", arrival_date: "25-1-2018", departure_date: "1-2-2018")
        booking.save
        expect(Booking.all.include? @booking_1).to eq(true)
        expect(Booking.all.include? @booking_2).to eq(true)
        expect(Booking.all.include? booking).to eq(false)        
        expect(Booking.all.length).to eq(2)
      end
    end
  end
  
  describe "next_after_date" do
    before :each do 
      @booking_1 = FactoryBot.create(:booking, name: "test_1", arrival_date: "20-1-2018", departure_date: "25-1-2018")
      @booking_2 = FactoryBot.create(:booking, name: "test_2", arrival_date: "31-1-2018", departure_date: "5-2-2018")
    end
    
    it "gets the booking after the given date" do
      current_date = Date.new(2018, 1, 27)
      expect(Booking.next_after_date(current_date)).to eq(@booking_2)
    end
    
    it "returns nil if there are no bookings after the given date" do
      current_date = Date.new(2018, 2, 8)
      expect(Booking.next_after_date(current_date)).to eq(nil)      
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
