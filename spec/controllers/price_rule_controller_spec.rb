require 'rails_helper'

RSpec.describe PriceRuleController, type: :controller do
    describe "index" do
        
        it "assings @price_rules to an empty array when there are no price rules" do
            get :index
            expect(assigns(:price_rules)).to eq([])
        end
        
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
    
    describe "show" do
        before :all do
            @rule_1 = FactoryBot.create(:price_rule, id: 1, name: "Base Rate", value: 185, period_type: "per_night", min_people: 1, max_people: 2, min_stay_duration: 2, max_stay_duration: 6, 
                start_date: "10-2-2018", end_date: "14-2-2018", description: "A base rate of $185 per night applies for 1 to 2 people.")            
        end
        
        it "assigns @price_rule to the rule matching the id" do
            get :show, params: {id: @rule_1.id}
            expect(assigns(:price_rule)).to eq(@rule_1)
        end
        
        describe "invalid id" do
            it "sets flash[:alert] when an invalid id is given" do
                get :show, params: {id: "junk"}
                expect(flash[:alert]).to eq("No price rule with id \"junk\" found!")
            end
            
            it "redirects when an invalid id is given" do
                get :show, params: {id: "junk"}
                expect(response).to redirect_to(administration_price_manager_path)                
            end
        end
    end
    
    
    describe "edit" do
        before :each do
            @rule_1 = FactoryBot.create(:price_rule, id: 2, name: "Base Rate", value: 185, period_type: "per_night", min_people: 1, max_people: 2, min_stay_duration: 2, max_stay_duration: 6, 
                start_date: "10-2-2018", end_date: "14-2-2018", description: "A base rate of $185 per night applies for 1 to 2 people.")
        end
        
        it "assigns @price_rule to the rule matching the id" do
            get :edit, params: {id: @rule_1.id}
            expect(assigns(:price_rule)).to eq(@rule_1)
        end
        
        describe "invalid id" do
            it "sets flash[:alert] when an invalid id is given" do
                get :edit, params: {id: "junk"}
                expect(flash[:alert]).to eq("No price rule with id \"junk\" found!")
            end
            
            it "redirects when an invalid id is given" do
                get :edit, params: {id: "junk"}
                expect(response).to redirect_to(administration_price_manager_path)                
            end
        end
    end
    
    describe "update" do

        before :each do
            @rule_1 = FactoryBot.create(:price_rule, id: 2, name: "Base Rate", value: 185, period_type: "per_night", min_people: 1, max_people: 2, min_stay_duration: 2, max_stay_duration: 6, 
                start_date: "10-2-2018", end_date: "14-2-2018", description: "A base rate of $185 per night applies for 1 to 2 people.")
            @new_values = {name: "new_name", value: 50, period_type: "fixed", max_people: 4, description: "Additonal people are charged at $30 per night."}                  
        end
        
        after :each do
            expect(response).to redirect_to(administration_price_manager_path)
        end
        
        describe "valid params" do
            it "updates an existing price rule with the new parameters" do
                put :update, params: {id: @rule_1.id, price_rule: @new_values}
                price_rule = PriceRule.find_by(id: 2)
                expect(price_rule.name).to eq(@new_values[:name])
                expect(price_rule.value).to eq(@new_values[:value])
                expect(price_rule.period_type).to eq(@new_values[:period_type]) 
                expect(price_rule.max_people).to eq(@new_values[:max_people])
                expect(price_rule.description).to eq(@new_values[:description])                
            end
            
            it "leaves other values untouched" do
                put :update, params: {id: @rule_1.id, price_rule: @new_values}
                price_rule = PriceRule.find_by(id: 2)
                expect(price_rule.min_people).to eq(@rule_1.min_people)
                expect(price_rule.min_stay_duration).to eq(@rule_1.min_stay_duration)
                expect(price_rule.max_stay_duration).to eq(@rule_1.max_stay_duration) 
                expect(price_rule.start_date).to eq(@rule_1.start_date)
                expect(price_rule.end_date).to eq(@rule_1.end_date)           
            end 
            
            it "assigns flash[:notification] to reflect a successful update" do
                put :update, params: {id: @rule_1.id, price_rule: @new_values}
                expect(flash[:notification]).to eq("Rule succesfully updated")
            end
        end
        
        describe "invalid params" do
            it "assigns flash[:alert] to a warning message" do
                put :update, params: {id: "junk", price_rule: @new_values}
                expect(flash[:alert]).to eq("Invalid attribute(s) given. No changes have been made.")                
            end
        end
    end
    
end
