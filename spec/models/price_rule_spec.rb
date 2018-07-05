require 'rails_helper'

RSpec.describe PriceRule, type: :model do

  describe "attributes" do
    it "has a name attribute" do
      expect(FactoryBot.build(:price_rule)).to respond_to(:name)
    end
    
    it "has a value attribute" do
      expect(FactoryBot.build(:price_rule)).to respond_to(:value)
    end
    
    it "has a period_type attribute" do
      expect(FactoryBot.build(:price_rule)).to respond_to(:period_type)
    end
    
    it "has a min_people attribute" do
      expect(FactoryBot.build(:price_rule)).to respond_to(:min_people)
    end
    
    it "has a max_people attribute" do
      expect(FactoryBot.build(:price_rule)).to respond_to(:max_people)
    end
    
    it "has a start_date attribute" do
      expect(FactoryBot.build(:price_rule)).to respond_to(:start_date)
    end
    
    it "has an end_date attribute" do
      expect(FactoryBot.build(:price_rule)).to respond_to(:end_date)
    end
    
    it "has a min_stay_duration attribute" do
      expect(FactoryBot.build(:price_rule)).to respond_to(:min_stay_duration)
    end
    
    it "has a max_stay_duration attribute" do
      expect(FactoryBot.build(:price_rule)).to respond_to(:max_stay_duration)
    end
    
    it "has a description attribute" do
      expect(FactoryBot.build(:price_rule)).to respond_to(:description)
    end          
  end
 
end
