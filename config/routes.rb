Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/administration/login' => "session#new"
  post '/administration/login' => "session#create"
  
  delete 'administration/logout' => "session#destroy"
  
  get '/administration/booking_manager' => "booking#index"
  
  get 'administration/price_manager'    => "price_rule#index"
  
  resources :booking, except: [:index]
  
  resources :price_rule, except: [:index]
  
  get '/reservation' => "booking#new_customer_booking"
  
  get '/reservation/calendar' => "booking#render_customer_reservation_calendar"
  
  post '/reservation' => "booking#create_customer_booking"
  
  get '/price_estimation' => "price_rule#estimate_price"
end
