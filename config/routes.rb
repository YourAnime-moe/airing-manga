Rails.application.routes.draw do
  root "home#index"
  get :discover, to: "home#index", as: :discover_now
  get '/discover/:id', to: "home#discover", as: :discover
  get :discoveries, to: "home#discoveries"

  match '/login/youranime', to: "login#youranime", via: [:get, :post]
  post '/login/mangadex', to: "login#mangadex"

  get '/auth/misete/callback', to: "login#youranime_callback"

  delete :logout, to: "login#logout"

  resources :manga, only: :show
end
