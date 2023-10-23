Rails.application.routes.draw do
  #post 'authenticate', to: 'authentication#authenticate'#endpointを揃うため移動

  namespace :api do
    namespace :v1 do
      post 'auth'=>'auth#create'
      resources :microposts
      resources :users

    end
  end
end
