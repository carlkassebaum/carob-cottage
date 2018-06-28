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
end
