require 'rails_helper'

RSpec.describe Administrator, type: :model do
  describe "attributes" do
    it "has a name attribute" do
      expect(FactoryBot.build(:administrator, name: "name", email_address: "address@email.com")).to respond_to(:name)
    end
    
    it "has an email address attribute" do
      expect(FactoryBot.build(:administrator, name: "name", email_address: "address@email.com")).to respond_to(:email_address)
    end
    
    it "has a password digest attribute" do 
      expect(FactoryBot.build(:administrator, name: "name", email_address: "address@email.com")).to respond_to(:password_digest)        
    end
  end
  
  describe "secure password" do
    it "allows users to set a password and a confirmation" do
      test_user = FactoryBot.create(:administrator, 
                                    name: "name", 
                                    email_address: "address@email.com", 
                                    password: "mypassword", 
                                    password_confirmation: "mypassword"
                                    )
      expect(test_user).not_to eq(false)
    end
  end
end
