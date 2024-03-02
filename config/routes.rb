Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth' => 'auth#create'
      delete 'auth' => 'auth#destroy'

      # If you want a route to list all microposts, add this line:
      resources :microposts, only: [:index]

      resources :users do
        resources :microposts, except: [:new, :edit] do
          member do
            post 'likes', to: 'likes#create'
            delete 'likes', to: 'likes#destroy'
          end
        end

        member do
          post 'follow', to: 'relationships#follow'
          delete 'unfollow', to: 'relationships#unfollow'
        end
      end
    end
  end
end
