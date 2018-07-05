RSpec.describe PriceRuleController, type: :routing do
    it 'routes get /administration/price_manager to PriceRule#index' do
        expect(get: "/administration/price_manager").to route_to( controller: "price_rule", action: "index")        
    end
    
    it 'routes get /price_rule/id to PriceRule#show' do
        expect(get: "/price_rule/1").to route_to( controller: "price_rule", action: "show", id: "1")        
    end
end