Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'devise/registrations',
    sessions: 'devise/sessions'
  }
  resources :users

  devise_scope :user do
    post 'devise/guest_sign_in', to: 'users/session#new_guest' 
  end

  root 'graphs#index'
  post 'graphs/guest_sign_in', to: 'graphs#new_guest'
  resources :graphs
end
