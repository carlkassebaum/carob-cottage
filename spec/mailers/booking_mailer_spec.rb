require "rails_helper"

RSpec.describe BookingMailer, type: :mailer do
    describe "booking_confirmation_email" do
        
        before :each do
            @booking_1 = FactoryBot.create(:booking, email_address: "bob@domain.com", name: "test_1", arrival_date: "20-1-2018", departure_date: "25-1-2018")            
        end
        
        let(:mail) { BookingMailer.booking_confirmation_email(@booking_1) }
        
        it "renders the headers" do
          expect(mail.subject).to eq("Carob Cottage: Reservation Confirmation")
          expect(mail.to).to eq(["bob@domain.com"])
          expect(mail.from).to eq(["staycarobcottage@gmail.com"])
        end
        
        it "does not fail" do
            BookingMailer.booking_confirmation_email(@booking_1).deliver_later
        end
    end
end
