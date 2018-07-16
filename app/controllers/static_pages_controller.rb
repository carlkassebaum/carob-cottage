class StaticPagesController < ApplicationController
    def home
        @body_id = "home"
    end
    
    def location
        @body_id = "location"
    end
    
    def gallery
        @body_id = "gallery"
    end
    
    def terms_and_conditions
        @body_id = "terms_and_conditions"
    end
    
    def contact_us
        @body_id = "contact_us"
    end
    
    def contact_us_message
        @body_id = "contact_us"
        flash[:notification] = "Thanks for sending us a message! We'll get back to you as soon as we can :)"
        Administrator.all do | admin |
            CustomerMail.customer_email(admin.email_address).deliver_later
        end
        redirect_to contact_us_path 
    end
end
