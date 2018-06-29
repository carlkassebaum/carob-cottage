require 'rails_helper'

RSpec.describe AdministratorController, type: :routing do
    it 'routes get /administration to administrator#index' do
        expect(get: "/administration").to route_to( controller: "administrator", action: "index")        
    end
end
