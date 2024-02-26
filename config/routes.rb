Rails.application.routes.draw do
  #post 'authenticate', to: 'authentication#authenticate'#endpointを揃うため移動

  namespace :api do
    namespace :v1 do
      post 'auth'=>'auth#create'
      delete 'auth' => 'auth#destroy'
      resources :users do
        resources :microposts, except: [:index]
      end

      # Define the index route for microposts separately
      get 'microposts' => 'microposts#index'
    end
  end
end