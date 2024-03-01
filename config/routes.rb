
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth' => 'auth#create'
      delete 'auth' => 'auth#destroy'

      resources :users do
        resources :microposts, only: [:index] do
          member do
            post 'likes', to: 'likes#create' , only: [:create]
          end
        end

        # User-specific member actions
        member do
          post 'follow', to: 'relationships#follow'
          delete 'unfollow', to: 'relationships#unfollow'
        end
        
        # Separate index route for microposts if needed
        get 'microposts', to: 'microposts#index'
      end
    end
  end
end
