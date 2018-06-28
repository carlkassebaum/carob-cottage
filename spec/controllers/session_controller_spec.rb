require 'rails_helper'

RSpec.describe SessionController, type: :controller do
    it 'routes get /administration/login to session#new' do
        expect(get: "/administration/login").to route_to( controller: "session", action: "new")        
    end
    
    it 'routes post /administration/login to session#create' do
        expect(post: "/administration/login").to route_to( controller: "session", action: "create")               
    end
end
