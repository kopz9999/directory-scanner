Rails.application.routes.draw do
  resources :directories
  namespace :api do
    resources :directories do
      post :search, on: :collection
    end
  end

  root 'directories#index'
end
