RSpec.describe PriceRuleController, type: :routing do
    it 'routes get /administration/price_manager to PriceRule#index' do
        expect(get: "/administration/price_manager").to route_to( controller: "price_rule", action: "index")        
    end
    
    it 'routes get /price_rule/id to PriceRule#show' do
        expect(get: "/price_rule/1").to route_to( controller: "price_rule", action: "show", id: "1")        
    end
    
    it 'routes get /price_rule/id/edit to PriceRule#edit' do
        expect(get: "/price_rule/1/edit").to route_to( controller: "price_rule", action: "edit", id: "1")               
    end
    
    it 'routes put /price_rule/id to PriceRule#update' do
        expect(put: "/price_rule/1").to route_to( controller: "price_rule", action: "update", id: "1")            
    end
    
    it 'routes delete /price_rule/id to PriceRule#destroy' do
        expect(delete: "/price_rule/1").to route_to( controller: "price_rule", action: "destroy", id: "1")          
    end
end