Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth' => 'auth#create'
      delete 'auth' => 'auth#destroy'

      resources :users do
        # Nested routes for microposts related to a user
        resources :microposts, except: [:index]

        # Member routes for follow and unfollow actions
        member do
          post 'follow', to: 'relationships#follow'
          delete 'unfollow', to: 'relationships#unfollow'
        end
      end

      # Define the index route for microposts separately
      get 'microposts', to: 'microposts#index'
    end
  end
end
