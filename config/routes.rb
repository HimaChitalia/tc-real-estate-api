Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do

      # /api/v1/users => for signup of new users
      resources :users, only: [:create]

      # /api/v1/auth => for the loging of existing new users
      post '/auth', to: "auth#login"

      # /api/v1/auth/refresh => for refreshing token
      post '/auth/refresh', to: "auth#refresh"

    end
  end
end
