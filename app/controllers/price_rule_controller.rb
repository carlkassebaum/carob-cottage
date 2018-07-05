class PriceRuleController < ApplicationController
    
    def show
        find_or_redirect
    end
    
    def index
        @price_rules = PriceRule.all
    end
    
    def edit
        find_or_redirect
    end
    
    def update
        price_rule = PriceRule.find_by(id: params[:id])
        
        
        
        if !price_rule.nil? && price_rule.update(price_rule_params)
            flash[:notification] = "Rule succesfully updated"
        else
            flash[:alert] = "Invalid attribute(s) given. No changes have been made."            
        end
        
        redirect_to(administration_price_manager_path)
    end
    
    private
    
    def find_or_redirect
        @price_rule = PriceRule.find_by(id: params[:id])
        
        if(@price_rule.nil?)
            flash[:alert] = "No price rule with id \"#{params[:id]}\" found!"
            redirect_to(administration_price_manager_path)   
        end
    end
    
    def price_rule_params
        params.require(:price_rule).permit(:name, :value, :period_type, :min_people, :max_people, :min_stay_duration, :max_stay_duration, 
        :description, :start_date, :end_date)
    end
end
