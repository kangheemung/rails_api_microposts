Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth' => 'auth#create'
      delete 'auth' => 'auth#destroy'
       resources :users do
        resources :microposts, except: [:new,:show,:edit] do
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
end
