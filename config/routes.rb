Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/administration/login' => "session#new"
  post '/administration/login' => "session#create"
  
  delete 'administration/logout' => "session#destroy"
  
  get '/administration' => "administrator#index"
  
  get '/administration/booking_manager' => "booking#index"
end
