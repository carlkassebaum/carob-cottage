class BookingController < ApplicationController
    include DateValidation
   
    before_action :redirect_unless_logged_in, only: [:index, :update, :create, :destroy]
    before_action :js_redirect_unless_logged_in, only: [:new, :show, :edit]
   
    def index
        @calendar_options={header_class: "full_reservation_calendar_headers", body_class: "full_reservation_calendar_body"}
        unless /^\d{4}$/.match(params[:year]).nil?
            @calendar_year = params[:year].to_i
        else
            @calendar_year = Date.today.year            
        end
        
        date_range = Date.new(@calendar_year,1,1)..Date.new(@calendar_year,12,31)
        bookings   = Booking.bookings_within(date_range)
        
        @year_reservations = {}
        
        #Build the year reservations calendar
        bookings.each do | booking |
            date_range = (booking.arrival_date..booking.departure_date).to_a
            date_range.map.with_index do |date, index|
                next if date.year != @calendar_year
                current_month = Date::MONTHNAMES[date.mon]
                @year_reservations[current_month] = {} if @year_reservations[current_month].nil?
                if index == 0
                    type = "arrive"
                elsif index == date_range.length - 1
                    type = "depart"
                else
                    type = "stay"
                end
                @year_reservations[current_month][date.mday] = {} if @year_reservations[current_month][date.mday].nil?
                @year_reservations[current_month][date.mday][type] = {id: booking, status: booking.status}
            end
        end
    end
    
    def show
        assign_booking_with_alert_ajax(params[:id])      
    end
    
    def edit
        assign_booking_with_alert_ajax(params[:id])           
    end
    
    def update
        booking = Booking.find_by(id: params[:id])
        error_attributes = check_for_date_errors

        if !booking.nil? && error_attributes.length == 0 && booking.update(booking_params)
            flash[:notification] = "Booking #{booking.id} sucessfully updated"
        else
            flash[:alert] = "No changes made."
            booking.errors.each { | attribute, error_message | flash[:alert] += " #{error_message}" } unless booking.nil?
            flash[:alert] += " Invalid arrival date given." if error_attributes.include? :arrival_date
            flash[:alert] += " Invalid departure date given." if error_attributes.include? :departure_date            
        end
        
        redirect_to administration_booking_manager_path        
    end
    
    def new
        @booking = Booking.new
    end
    
    def create
        @booking = Booking.new(booking_params)
        error_attributes = check_for_date_errors
        
        if error_attributes.length == 0 && @booking.save
            flash[:notification] = "New Booking succesfully created"
        else
            flash[:alert] = "Booking not created."
            @booking.errors.each do | attribute, error_message |
                flash[:alert] += " #{error_message}"
            end
            flash[:alert] += " Invalid arrival date given." if error_attributes.include? :arrival_date
            flash[:alert] += " Invalid departure date given." if error_attributes.include? :departure_date            
        end
        
        redirect_to(administration_booking_manager_path)
    end
    
    def destroy
        begin
            booking = Booking.find(params[:id])
            booking.destroy
            flash[:notification] = "Booking successfully deleted"
        rescue ActiveRecord::RecordNotFound
            flash[:alert] = "Booking with id \"#{params[:id]}\" not found!" unless params[:id].empty?
            flash[:alert] = "No Booking id given!" if params[:id].empty?
        end
        redirect_to(administration_booking_manager_path)
    end
    
    private
    
    def assign_booking_with_alert_ajax(id)
        @booking = Booking.find_by(id: id)
        
        if(@booking.nil?)
            flash[:alert] = "There is no matching booking with an id of #{id}."
        end
        
        #Respond with javascript
        respond_to do |format|
            format.js
        end          
    end
    
    def booking_params
        params.require(:booking).permit(:name, :cost, :status, :email_address, :contact_number, :number_of_people, :estimated_arrival_time, 
        :preferred_payment_method, :arrival_date, :departure_date, :postcode, :country)
    end
    
    def check_for_date_errors
        error_attributes = []
        
        error_attributes << :arrival_date unless valid_date?(booking_params[:arrival_date])
        error_attributes << :departure_date unless valid_date?(booking_params[:departure_date])
        
        unless error_attributes.include?(:arrival_date) || error_attributes.include?(:departure_date)
            error_attributes << :departure_date unless date_less_than?(booking_params[:arrival_date], booking_params[:departure_date])
        end
        
        return error_attributes
    end
end
