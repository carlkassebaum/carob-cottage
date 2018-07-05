class PriceRuleController < ApplicationController
    
    def index
        @price_rules = PriceRule.all
    end
end
