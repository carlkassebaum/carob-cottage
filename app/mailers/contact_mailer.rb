class ContactMailer < ApplicationMailer
    def customer_email(admin_email_address)
        mail to: admin_email_address, subject: "Carob Cottage: Customer Message"
    end
end
