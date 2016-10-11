Rails.application.routes.draw do
  devise_for :users , controllers: 
    { sessions: 'users/sessions', 
      registrations: 'users/registrations',
      passwords: 'users/passwords' }
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "dashboard#index"
  resources :dashboard, only: [:index, :create]
  resources :backup, only: [:show]
  resources :track, only: [:show]  
  
  match 'backup/restore',  to: 'backup#restore',    via: :post
  
  namespace :api do
    resources :files, only: [:index]
    resources :backup, only: [:create, :update, :show]
    match 'stats', to: 'backup#stats', via: :get
  end
end

