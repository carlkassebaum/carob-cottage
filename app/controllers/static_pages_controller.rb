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
end
