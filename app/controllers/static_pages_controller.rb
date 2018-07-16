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
end
