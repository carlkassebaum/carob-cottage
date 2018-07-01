require 'rails_helper'

RSpec.describe Booking, type: :model do
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
