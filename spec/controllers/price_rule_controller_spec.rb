require 'rails_helper'

RSpec.describe PriceRuleController, type: :controller do
    describe "index" do
        it "assings @price_rules to an array of all current price rules" do
            rule_1 = FactoryBot.create(:price_rule, name: "Base Rate", value: 185, period_type: "per_night", min_people: 1, max_people: 2, min_stay_duration: 2, max_stay_duration: 6, 
                description: "A base rate of $185 per night applies for 1 to 2 people.")
            rule_2 = FactoryBot.create(:price_rule, name: "Additonal People", 
                value: 30, period_type: "per_night", min_people: 3, 
                description: "Additonal people are charged at $30 per night.")
            rule_3 = FactoryBot.create(:price_rule, name: "Easter", value: 205, period_type: "per_night", min_people: 1, max_people: 2, start_date: "19-4", end_date: "22-4",
                description: "Stays during the Easter period are charged at $205 per night.")
            rule_4 = FactoryBot.create(:price_rule, name: "Cleaning", value: 10, period_type: "fixed",
                description: "Stays during the Easter period are charged at $205 per night.")
            rule_5 = FactoryBot.create(:price_rule, name: "7 night stay", value: 170, period_type: "per_night", min_people: 1, max_people: 2,
                min_stay_duration: 7, max_stay_duration: 7, description: "Stays for 7 nights are charged at $170 per night.")
            rule_6 = FactoryBot.create(:price_rule, name: "Stays longer than 7 nights", value: 165, period_type: "per_night", min_people: 1, max_people: 2,
                min_stay_duration: 8, description: "Stays for 8 or more nights are charged at $165 per night.")
                
            get :index
            expect(assigns(:price_rules).include?rule_1).to eq(true)
            expect(assigns(:price_rules).include?rule_2).to eq(true)
            expect(assigns(:price_rules).include?rule_3).to eq(true)
            expect(assigns(:price_rules).include?rule_4).to eq(true)
            expect(assigns(:price_rules).include?rule_5).to eq(true)
            expect(assigns(:price_rules).include?rule_6).to eq(true)
            expect(assigns(:price_rules).length).to eq(6)
        end
        
        
    end
end
