require 'rails_helper'

RSpec.describe SessionController, type: :controller do
    describe "create" do
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
        
        describe "valid login" do
            it "redirects to the administrator home page with correct login details" do
                post :create, params: {session: {email_address: @valid_email_address, password: @valid_password}}
                expect(response).to redirect_to(administration_path)
            end
        end
        
        describe "invalid login" do
            describe "redirection" do
                it "redirects to the login page when an invalid email address is given" do
                    post :create, params: {session: {email_address: "invalid_email@outlook.com", password: @valid_password}}
                    expect(response).to redirect_to(administration_login_path)
                end
                it "redirects to the login page when an invalid password is given" do
                    post :create, params: {session: {email_address: @valid_email_address, password: "invalid_password"}}
                    expect(response).to redirect_to(administration_login_path)
                end
                it "redirects to the login page when both an invalid email address and password is given" do
                    post :create, params: {session: {email_address: "invalid_email_addres@domain.com", password: "invalid_password"}}
                    expect(response).to redirect_to(administration_login_path)
                end
            end
            
            describe "error message" do
                it "shows an error message when an invalid email address is given"
                it "shows an error messgae when an invalid password is given"
                it "shows an error message when an invalid email address and password is given"
            end
        end
    end
end
