class ApplicationController < ActionController::Base
    protected 
    def redirect_unless_logged_in
        if session[:logged_in] != true
            session[:logged_in] = nil
            flash[:alert] = "You must be logged in to view that content"
            redirect_to administration_login_path            
        end
    end
    
    def js_redirect_unless_logged_in
        if session[:logged_in] != true
            session[:logged_in] = nil
            flash[:alert] = "You must be logged in to view that content"         
            render :js => "window.location = '#{administration_login_path}'"
        end
    end
end
