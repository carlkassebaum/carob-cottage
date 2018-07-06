require 'rails_helper'

RSpec.describe PriceRuleController, type: :controller do
    describe "index" do
        
        describe "logged out" do
            before :each do
                session[:logged_in] = nil                
            end
            
            it "redirects and sets flash[:alert]" do
                get :index
                expect(flash[:alert]).to eq("You must be logged in to view that content")
                expect(response).to redirect_to(administration_login_path)
            end
            
            it "does not assigns @price_rules" do
                get :index
                expect(assigns(:price_rule)).to eq(nil)
            end
        end
        
        describe "logged in" do
            before :each do
                session[:logged_in] = true
            end
            
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
    end
    
    describe "show" do
       
        describe "logged out" do
            before :each do
                @rule_1 = FactoryBot.create(:price_rule, id: 1, name: "Base Rate", value: 185, period_type: "per_night", min_people: 1, max_people: 2, min_stay_duration: 2, max_stay_duration: 6, 
                    start_date: "10-2-2018", end_date: "14-2-2018", description: "A base rate of $185 per night applies for 1 to 2 people.")
                session[:logged_in] = nil
            end
            
            it "redirects and sets flash[:alert]" do
                get :show, params: {id: @rule_1.id}
                expect(flash[:alert]).to eq("You must be logged in to view that content")
                expect(response).to redirect_to(administration_login_path)
            end
            
            it "does not assign @price_rule" do
                get :show, params: {id: @rule_1.id}
                expect(assigns(:price_rule)).to eq(nil)
            end
        end
        
        describe "logged in" do
            before :each do
                session[:logged_in] = true 
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
    end
    
    
    describe "edit" do
        describe "logged out" do
            before :each do
                @rule_1 = FactoryBot.create(:price_rule, id: 1, name: "Base Rate", value: 185, period_type: "per_night", min_people: 1, max_people: 2, min_stay_duration: 2, max_stay_duration: 6, 
                    start_date: "10-2-2018", end_date: "14-2-2018", description: "A base rate of $185 per night applies for 1 to 2 people.")                 
                session[:logged_in] = nil                
            end
            
            it "redirects and sets flash[:alert]" do
                get :edit, params: {id: @rule_1.id}
                expect(flash[:alert]).to eq("You must be logged in to view that content")
                expect(response).to redirect_to(administration_login_path)
            end
            
            it "does not assign @price_rule" do
                get :edit, params: {id: @rule_1.id}
                expect(assigns(:price_rule)).to eq(nil)
            end
        end
        
        describe "logged in" do
            before :each do
                session[:logged_in] = true
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
    end
    
    describe "update" do
        describe "logged out" do
            before :each do
                session[:logged_in] = nil                   
                @rule_1 = FactoryBot.create(:price_rule, id: 1, name: "Base Rate", value: 185, period_type: "per_night", min_people: 1, max_people: 2, min_stay_duration: 2, max_stay_duration: 6, 
                    start_date: "10-2-2018", end_date: "14-2-2018", description: "A base rate of $185 per night applies for 1 to 2 people.") 
                @new_values = {name: "new_name", value: 50, period_type: "fixed", max_people: 4, description: "Additonal people are charged at $30 per night."}                  
            end
            
            it "redirects and sets flash[:alert]" do
                put :update, params: {id: @rule_1.id, price_rule: @new_values}
                expect(flash[:alert]).to eq("You must be logged in to view that content")
                expect(response).to redirect_to(administration_login_path)
            end
            
            it "does not update any attributes" do
                put :update, params: {id: @rule_1.id, price_rule: @new_values}
                resulting_rule = PriceRule.find_by(id: @rule_1.id)
                expect(resulting_rule).to eq(@rule_1)                
            end
        end        
        
        describe "logged in" do
            before :each do
                session[:logged_in] = true
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
    
    describe "new" do
        describe "logged out" do
            before :each do
                session[:logged_in] = nil                   
            end
            
            it "redirects and sets flash[:alert]" do
                get :new
                expect(flash[:alert]).to eq("You must be logged in to view that content")
                expect(response).to redirect_to(administration_login_path)
            end
            
            it "does not assign @price_rule" do
                get :new
                expect(assigns(:price_rule)).to eq(nil)
            end
        end        
        
        describe "logged in" do
            it "assigns @price_rule to an empty rule" do
                session[:logged_in] = true
                get :new
                expect(assigns(:price_rule).to_json).to eq(FactoryBot.build(:price_rule, {}).to_json)            
            end
        end
    end
    
    describe "destroy" do
        describe "logged out" do
            before :each do
                session[:logged_in] = nil                   
                @rule_1 = FactoryBot.create(:price_rule, id: 1, name: "Base Rate", value: 185, period_type: "per_night", min_people: 1, max_people: 2, min_stay_duration: 2, max_stay_duration: 6, 
                    start_date: "10-2-2018", end_date: "14-2-2018", description: "A base rate of $185 per night applies for 1 to 2 people.") 
            end
            
            it "redirects and sets flash[:alert]" do
                delete :destroy, params: {id: @rule_1.id}
                expect(flash[:alert]).to eq("You must be logged in to view that content")
                expect(response).to redirect_to(administration_login_path)
            end
            
            it "does not remove the given id" do
                delete :destroy, params: {id: @rule_1.id}
                resulting_rule = PriceRule.find_by(id: @rule_1.id)
                expect(resulting_rule).to eq(@rule_1)               
            end
        end
        
        describe "logged in" do
            before :each do
                session[:logged_in] = true
                @rule_1 = FactoryBot.create(:price_rule, id: 2, name: "Delete specific", value: 185, period_type: "per_night", min_people: 1, max_people: 2, min_stay_duration: 2, max_stay_duration: 6, 
                    start_date: "10-2-2018", end_date: "14-2-2018", description: "A base rate of $185 per night applies for 1 to 2 people.")         
            end
            
            describe "valid id" do
                it "removes the corresponding database entry with a given id" do
                    delete :destroy, params: {id: @rule_1.id}              
                    expect(PriceRule.all).to eq([])
                end
                
                it "sets flash[:notification] to a success message" do
                    delete :destroy, params: {id: @rule_1.id}                 
                    expect(flash[:notification]).to eq("Price rule \"Delete specific\" succesfully deleted")
                end
                
                it "redirects to the administration price manager page" do
                    delete :destroy, params: {id: @rule_1.id}                 
                    expect(response).to redirect_to(administration_price_manager_path)
                end
            end
            
            describe "invalid id" do
                before :each do
                    delete :destroy, params: {id: "junk"}                   
                end
                
                it "sets flash[:alert] to an error message" do
                    expect(flash[:alert]).to eq("No price rule with id \"junk\" found!")              
                end
                
                it "redirects to the administration price manager page" do
                    expect(response).to redirect_to(administration_price_manager_path)                
                end
            end
        end
    end
    
    describe "create" do
        describe "logged out" do
            before :each do
                session[:logged_in] = nil                   
                @new_values = {name: "new_name", value: 50, period_type: "fixed", max_people: 4, description: "Additonal people are charged at $30 per night."}                    
            end
            
            it "redirects and sets flash[:alert]" do
                post :create, params: {price_rule: @new_values}
                expect(flash[:alert]).to eq("You must be logged in to view that content")
                expect(response).to redirect_to(administration_login_path)
            end
            
            it "does not create the new price rule" do
                post :create, params: {price_rule: @new_values}
                expect(PriceRule.all).to eq([])
            end
        end        
        
        describe "logged in" do
            before :each do
                session[:logged_in] = true
                @new_values= {name: "Base Rate", value: 185, period_type: "per_night", min_people: 1, max_people: 2, min_stay_duration: 2, max_stay_duration: 6, 
                    start_date: "10-2-2018", end_date: "14-2-2018", description: "A base rate of $185 per night applies for 1 to 2 people."}
            end
        
            describe "valid params" do
                it "creates a new price rule with the new parameters" do
                    post :create, params: {price_rule: @new_values}
                    price_rule = PriceRule.first
                    expect(price_rule.name).to eq(@new_values[:name])
                    expect(price_rule.value).to eq(@new_values[:value])
                    expect(price_rule.period_type).to eq(@new_values[:period_type]) 
                    expect(price_rule.max_people).to eq(@new_values[:max_people])
                    expect(price_rule.description).to eq(@new_values[:description])
                    expect(price_rule.min_people).to eq(@new_values[:min_people])
                    expect(price_rule.min_stay_duration).to eq(@new_values[:min_stay_duration])
                    expect(price_rule.max_stay_duration).to eq(@new_values[:max_stay_duration]) 
                    expect(price_rule.start_date).to eq(@new_values[:start_date])
                    expect(price_rule.end_date).to eq(@new_values[:end_date]) 
                    expect(flash[:notification]).to eq("Rule succesfully created")
                    expect(response).to redirect_to(administration_price_manager_path)
                end
            end
            
            describe "invalid params" do
                it "requires a name and assigns flash[:alert] to a warning message" do
                    @new_values[:name] = ""
                    post :create, params: {price_rule: @new_values}
                    expect(flash[:alert]).to eq("Invalid attribute(s) given. No new rules have been created.")
                    expect(response).to render_template("new")
                end
            end
        end    
    end
end
