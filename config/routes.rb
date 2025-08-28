Rails.application.routes.draw do
  root to: 'products#index'
  get 'sign_in', to: 'sessions#new', as: :sign_in
  post 'sign_in', to: 'sessions#create'
  delete 'sign_out', to: 'sessions#destroy', as: :sign_out

  resources :addresses
  resources :employees, only: :index
  resources :orders, only: :show do
    resource :fulfill, only: [:create] do
      member do
        post :return_order
        post :restock_order
      end
    end
  end

  resources :products do
    post :restock, on: :member
    resource :receive, only: [:create]
  end
end
