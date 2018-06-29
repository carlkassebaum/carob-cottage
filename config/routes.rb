Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/administration/login' => "session#new"
  post '/administration/login' => "session#create"
  
  get '/administration' => "administrator#index"
end
