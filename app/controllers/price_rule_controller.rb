class PriceRuleController < ApplicationController
    before_action :redirect_unless_logged_in, except: [:estimate_price]
    
    def show
        find_or_redirect
    end
    
    def index
        @price_rules = PriceRule.all
    end
    
    def edit
        find_or_redirect
    end
    
    def destroy
        find_or_redirect
        
        if @price_rule != nil
            name = @price_rule.name
            @price_rule.destroy
            flash[:notification] = "Price rule \"#{name}\" succesfully deleted"
            redirect_to(administration_price_manager_path)
        end        
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
    
    def new
        @price_rule = PriceRule.new
    end
    
    def create
        @price_rule = PriceRule.new(price_rule_params)
        
        if @price_rule.save 
            flash[:notification] = "Rule succesfully created"
            redirect_to(administration_price_manager_path)
        else
            flash[:alert] = "Invalid attribute(s) given. No new rules have been created."
            render 'new'
        end
    end
    
    def estimate_price
        price = PriceRule.calculate_price(params[:number_of_people].to_i, params[:arrival_date], params[:departure_date])
        @price = "$#{price} (AUD)"
        
        respond_to do | format |
            format.js
        end
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
        :description, :start_date, :end_date, :rate_type)
    end
end
