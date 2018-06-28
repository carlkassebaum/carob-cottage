require 'rails_helper'

RSpec.describe SessionController, type: :controller do
    describe "create" do
        describe "valid login" do
            before(:each) do
                @valid_email_address = "test_email@domain.com"
                @valid_name = "bob"
                @valid_password = "foo_bar"
                @test_administrator = FactoryBot.create(:administrator,
                                                        name: @valid_name,
                                                        email_address: @valid_email_address,
                                                        password: @valid_password,
                                                        password_confirmation: @valid_password)
            end
            
            it "redirects to the administrator home page with correct login details" do
                post :create, session: {:email_address => @valid_email_address, :password => @valid_password}
                expect(response).to redirect_to(administrator_path)
            end
        end        
    end
end
