Rails.application.routes.draw do
  resources :users, only: [:show, :create, :destroy, :update]
end
