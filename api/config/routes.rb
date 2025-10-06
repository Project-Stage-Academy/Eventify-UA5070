Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      scope :auth do
        post :register, to: "auth#register"
        post :login, to: "auth#login"
      end

      scope :users do
        get :me, to: "users#me"
      end

      get :hello, to: "auth#hello"

      resources :events, only: [ :index, :show, :create ] do
        resources :organizers, only: [ :create, :destroy ], controller: "event_organizers"
      end
    end
  end
end
