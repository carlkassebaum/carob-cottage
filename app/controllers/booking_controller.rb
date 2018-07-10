class BookingController < ApplicationController
    
    OPTIONAL_PARAMS = ["postcode", "created_at", "updated_at", "id", "cost", "estimated_arrival_time"]
    DATE_PARAMS     = ["arrival_date", "departure_date"]
    
    CUSTOMER_DATE_ERRORS = 
    {
        name:                     "A customer name must be given",
        country:                  "You must specify your current country",
        contact_number:           "You must provide a contact number",
        email_address:            "You must provide an email address",
        number_of_people:         "You must specify how many adults are staying",
        arrival_date:             "You must select an arrival date",
        departure_date:           "You must select a departure date",
        preferred_payment_method: "You must select a payment method"
    }
    
    MIN_NIGHT_STAY = 2
    GUEST_SELECTOR = ["1 person", "2 people", "3 people", "4 people", "5 people"]
    CUSTOMER_BODY_ID="customer_page"
    
    include DateValidation
   
    before_action :redirect_unless_logged_in, only: [:index, :update, :create, :destroy]
    before_action :js_redirect_unless_logged_in, only: [:new, :show, :edit]
    before_action :is_customer_page,             only: [:new_customer_booking, :create_customer_booking]
   
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
            flash[:alert] += " Invalid arrival date given."   if error_attributes.include? :arrival_date
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
    
    def new_customer_booking
        @booking = Booking.new
        @form_errors = {}
        current_date = Date.today
        @start_date = Date.new(current_date.year, current_date.month, 1)
        @guest_selector = GUEST_SELECTOR
    end
    
    def create_customer_booking
        customer_params = customer_booking_params
        customer_params[:status] = "reserved"
        customer_params[:number_of_people] = extract_number_of_people(customer_params[:number_of_people])
        errors = check_customer_params_for_errors(customer_params)
        @booking = Booking.new(customer_params)
        @form_errors = {}
        errors.each do | error |
            @form_errors[error] = CUSTOMER_DATE_ERRORS[error]                
        end
        
        if @form_errors.empty? && @booking.save
            flash[:sucess] = "Your reservation request has been placed! You will receive a confirmation email shortly."
        else
            render "booking/new_customer_booking"
        end
    end
    
    def render_customer_reservation_calendar
        params[:start_date] = Date.parse(params[:start_date])
        raise ArgumentError.new("start date must be the first day of the month") if params[:start_date].mday != 1
        
        @start_date = params[:start_date]
        if params[:check_in_date].nil?
            response_action = "check_in_calendar"
            @blocked_dates = blocked_dates(:check_in, params)
        else
            response_action = "check_out_calendar"            
            @check_in_date  = params[:check_in_date]
            @check_out_date = params[:check_out_date]
            
            unless params[:hide_calendar] == "true"
                @hide_calendar = false
                params[:check_in_date] = Date.parse(params[:check_in_date])
                params[:check_out_date] = Date.parse(params[:check_out_date]) unless params[:check_out_date].nil?
                
                @blocked_dates  = blocked_dates(:check_out, params)
                @min_stay_dates = []
                (params[:check_in_date]..(params[:check_in_date] + (MIN_NIGHT_STAY-1).days)).to_a.each do | date |
                    @min_stay_dates << date.mday
                end
            else
                @hide_calendar = true
            end
        end
        
        respond_to do | format |
            format.js { render :action => "#{response_action}" }
        end
    end
    
    private
    
    def extract_number_of_people(number_of_guests)
        return nil if number_of_guests.nil?
        number_of_guests.slice! "people"
        number_of_guests.slice! "person"
        return number_of_guests
    end
    
    def blocked_dates(selector, calendar_params)
        start_date = calendar_params[:start_date]
        month = start_date..((start_date + 1.month).yesterday)
        blocked = []
        if (selector == :check_in)
            return get_blocked_checkin_dates(start_date, month)
        elsif (selector == :check_out)
            return get_blocked_checkout_dates(start_date, month, calendar_params[:check_in_date])
        end
        return blocked
    end
    
    def get_blocked_checkin_dates(start_date, month)
        blocked = []
        bookings_in_month = Booking.bookings_within(month)            
        if Date.today >= (start_date + 1.month)
            month.to_a.each { | date | blocked << date.mday }
        elsif month === Date.today || Date.today < start_date
            #block dates before today
            (start_date..Date.today.yesterday).to_a.each { | date | blocked << date.mday }
            #block dates after today
            bookings_in_month.each do | booking |
                start_date = booking.arrival_date - (MIN_NIGHT_STAY - 1).days
                end_date   = booking.departure_date - 1.days
                reserved_days = (start_date..end_date).to_a & month.to_a
                reserved_days.each { | day | blocked << day.mday unless blocked.include? day.mday }
            end
        end
        return blocked
    end
    
    def get_blocked_checkout_dates(start_date, month, check_in_date)
        #ensure the checkin date is valid
        check_in_start = Date.new(check_in_date.year, check_in_date.month,1)
        check_in_month = check_in_start..((check_in_start + 1.month).yesterday)
        raise ArgumentError.new("invalid check in date") if get_blocked_checkin_dates(check_in_start, check_in_month).include? check_in_date.day
        
        blocked = []
        next_booking = Booking.next_after_date(check_in_date)
        next_available_date = next_booking.nil? ? start_date + 1.month : next_booking.arrival_date
        available_dates_in_month = ((check_in_date+(MIN_NIGHT_STAY).days)..next_available_date).to_a & month.to_a
        month.to_a.each do | date |
            blocked << date.mday unless available_dates_in_month.include? date
        end
        
        return blocked
    end
    
    def check_customer_params_for_errors(customer_params)
        errors = []
        (Booking.column_names - OPTIONAL_PARAMS - DATE_PARAMS).each do | attribute | 
            if customer_params[attribute].nil? || customer_params[attribute].empty?
                errors << attribute.to_sym
            end
        end
        errors += check_for_date_errors
        
        return errors
    end
    
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
    
    def customer_booking_params
        params.require(:booking).permit(:name, :cost, :email_address, :contact_number, 
        :number_of_people, :estimated_arrival_time, :preferred_payment_method, 
        :arrival_date, :departure_date, :country, :postcode)
    end
    
    def booking_params
        params.require(:booking).permit(:name, :cost, :status, :email_address, :contact_number, :number_of_people, :estimated_arrival_time, 
        :preferred_payment_method, :arrival_date, :departure_date, :postcode, :country)
    end
    
    def is_customer_page
        @body_id = "customer_page"
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
