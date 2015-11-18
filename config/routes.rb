Rails.application.routes.draw do
  resources :directories do
    post :search, on: :collection
  end
end
