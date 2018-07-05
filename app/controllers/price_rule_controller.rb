class PriceRuleController < ApplicationController
    
    def show
        @price_rule = PriceRule.find_by(id: params[:id])
        
        if(@price_rule.nil?)
            flash[:alert] = "No price rule with id \"#{params[:id]}\" found!"
            redirect_to(administration_price_manager_path)   
        end
    end
    
    def index
        @price_rules = PriceRule.all
    end
end
