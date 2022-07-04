Rails.application.routes.draw do
  root "home#index"
  get :discover, to: "home#index", as: :discover_now
  get '/discover/:id', to: "home#discover", as: :discover
  get :discoveries, to: "home#discoveries"

  resources :manga, only: :show
end
