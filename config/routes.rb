Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :interviews
  resources :participants
  root 'interviews#index'
  get '/hello-world' => "participants#hello_world"
end
