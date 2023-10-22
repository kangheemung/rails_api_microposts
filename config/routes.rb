Rails.application.routes.draw do
  post 'authenticate', to: 'authentication#authenticate'

  namespace 'api' do
    namespace 'v1' do
      resources :microposts
      resources :users
    end
  end
end
