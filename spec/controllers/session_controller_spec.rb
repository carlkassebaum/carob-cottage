require 'rails_helper'

RSpec.describe SessionController, type: :controller do
    it 'routes get /login to session#new' do
        expect(get: "/administration/login").to route_to( controller: "session", action: "new")        
    end
end
