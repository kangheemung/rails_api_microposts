Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth' => 'auth#create'
      delete 'auth' => 'auth#destroy'
      get '/microposts/:id', to: 'microposts#show', as: 'micropost'
      resources :users do
        resources :microposts, except: [:new, :edit] do
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
      get 'users/:user_id/microposts/:id/edit', to: 'microposts#edit', as: 'edit_micropost'
    end
  end
end
