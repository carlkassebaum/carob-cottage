class SessionController < ApplicationController
    def new
    end
    
    def create
        admin = Administrator.find_by(email_address: params[:session][:email_address].downcase)
        if admin && admin.authenticate(params[:session][:password])
            session[:user_id] = admin.id
            redirect_to administration_path
        end
    end
end
