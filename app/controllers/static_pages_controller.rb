class StaticPagesController < ApplicationController
    def home
        @body_id = "home"
    end
    
    def location
        @body_id = "location"
    end
end
