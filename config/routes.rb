Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth' => 'auth#create'
      delete 'auth' => 'auth#destroy'
       resources :users do
        resources :microposts, except: [:new,:edit] do
          member do
            post 'like', to: 'likes#create'
            delete 'unlike', to: 'likes#destroy'
          end
        end

        member do
          post 'follow', to: 'relationships#follow'
          delete 'unfollow', to: 'relationships#unfollow'
        end
      end
    end
  end
    get 'api/v1/users/:user_id/microposts/:id', to: 'api/v1/microposts#show'
    get 'api/v1/users/:user_id/microposts/:id/edit', to: 'api/v1/microposts#edit'
end
