Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :cats, only: [:index, :show, :new, :edit, :create, :update]

  resources :cat_rental_requests, only: [:new, :create]

  patch 'cat_rental_requests/:id/approve', to: 'cat_rental_requests#approve', as: 'cat_rental_request_approve'

  patch 'cat_rental_requests/:id/deny', to: 'cat_rental_requests#deny', as: 'cat_rental_request_deny'
end
