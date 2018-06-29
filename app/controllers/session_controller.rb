class SessionController < ApplicationController
    def new
    end
    
    def create
        admin = Administrator.find_by(email_address: params[:session][:email_address].downcase)
        if admin && admin.authenticate(params[:session][:password])
            session[:user_id] = admin.id
            redirect_to administration_path
        else
            flash[:alert] = "Unkown email address or invalid password given"
            redirect_to administration_login_path
        end
    end
    
    def destroy
        if(!session[:user_id].nil?)
            session[:user_id] = nil
            flash[:notification] = "Sign out successful"            
        else
            flash[:alert] = "There was no administrator logged in"
        end
        redirect_to administration_login_path
    end
end
