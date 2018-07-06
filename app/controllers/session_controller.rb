class SessionController < ApplicationController
    def new
    end
    
    def create
        admin = Administrator.find_by(email_address: params[:session][:email_address].downcase)
        if admin && admin.authenticate(params[:session][:password])
            session[:logged_in] = true
            redirect_to administration_path
        else
            flash[:alert] = "Unkown email address or invalid password given"
            redirect_to administration_login_path
        end
    end
    
    def destroy
        if(!session[:logged_in].nil?)
            session[:logged_in] = nil
            flash[:notification] = "Sign out successful"            
        else
            flash[:alert] = "There was no administrator logged in"
        end
        redirect_to administration_login_path
    end
end
