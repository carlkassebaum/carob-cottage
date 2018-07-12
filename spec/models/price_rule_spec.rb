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
    
    it "has a rate type attribute" do
      expect(FactoryBot.build(:price_rule)).to respond_to(:rate_type)      
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
  
  describe "validation" do
    it "requires the name attribute to be given" do
      price_rule = PriceRule.new(name: "")
      expect(price_rule.save).to eq(false)
    end
  end
  
  describe "calculate_price" do
    before :each do
      @rule_1 = FactoryBot.create(:price_rule, name: "Base Rate", value: 185, period_type: "per_night", min_people: 1, max_people: 2, min_stay_duration: 2, max_stay_duration: 6, 
          description: "A base rate of $185 per night applies for 1 to 2 people.", rate_type: "all_guests")
      @rule_2 = FactoryBot.create(:price_rule, name: "Additonal People", 
          value: 30, period_type: "per_night", min_people: 3, 
          description: "Additonal people are charged at $30 per night.", rate_type: "per_person")
      @rule_3 = FactoryBot.create(:price_rule, name: "Easter", value: 205, period_type: "per_night", min_people: 1, max_people: 2, start_date: "19-4-2018", end_date: "22-4-2018",
          description: "Stays during the Easter period are charged at $205 per night.", rate_type: "all_guests")
      @rule_4 = FactoryBot.create(:price_rule, name: "Cleaning", value: 10, period_type: "fixed",
          description: "A cleaning fee of $10 is charged", rate_type: "all_guests")
      @rule_5 = FactoryBot.create(:price_rule, name: "7 night stay", value: 170, period_type: "per_night", min_people: 1, max_people: 2,
          min_stay_duration: 7, max_stay_duration: 7, description: "Stays for 7 nights are charged at $170 per night.", rate_type: "all_guests")
      @rule_6 = FactoryBot.create(:price_rule, name: "Stays longer than 7 nights", value: 165, period_type: "per_night", min_people: 1, max_people: 2,
          min_stay_duration: 8, description: "Stays for 8 or more nights are charged at $165 per night.", rate_type: "all_guests")
      @rule_7 = FactoryBot.create(:price_rule, name: "Additonal People Easter",  start_date: "19-4-2018", end_date: "23-4-2018",
          value: 45, period_type: "per_night", min_people: 3, 
          description: "Additonal people are charged at $45 per night over easter.", rate_type: "per_person")          
    end
    
    it "calculates the base rate for dates not within specific date ranges" do
      expect(PriceRule.calculate_price(4, "12-7-2018", "15-7-2018")).to eq(745)
    end
    
    it "calculates with reduced rates for stays which are 7 nights long" do
      expect(PriceRule.calculate_price(4, "12-7-2018", "19-7-2018")).to eq(1620)      
    end
    
    it "calculates with lower rates for stays which are longer than 7 nights" do
      expect(PriceRule.calculate_price(5, "12-7-2018", "20-7-2018")).to eq(2050)       
    end
    
    it "calculates the same price for 1 to 2 people" do
      expect(PriceRule.calculate_price(1, "12-7-2018", "14-7-2018")).to eq(380)
      expect(PriceRule.calculate_price(2, "12-7-2018", "14-7-2018")).to eq(380)         
    end
    
    it "calculates the rate higher for the easter period" do
      expect(PriceRule.calculate_price(3, "19-4-2018", "22-4-2018")).to eq(760)
    end
    
    it "varies the rate for bookings overlapping periods" do
      expect(PriceRule.calculate_price(4, "17-4-2018", "25-4-2018")).to eq(2120)      
    end
  end
end
