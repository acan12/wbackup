Rails.application.routes.draw do
  devise_for :users , controllers: 
    { sessions: 'users/sessions', 
      registrations: 'users/registrations',
      passwords: 'users/passwords' }
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "dashboard#index"
  resources :dashboard, only: [:index]
  resources :backup, only: [:create, :show]
  resources :track, only: [:show]  
end

