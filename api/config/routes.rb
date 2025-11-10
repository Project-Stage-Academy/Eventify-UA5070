Rails.application.routes.draw do
  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine => "/api-docs"
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

      scope :account do
        get :me, to: "account#me"
      end

      resources :events, only: [ :index, :show, :create, :update ] do
        get :joined, on: :collection
        resources :event_members, only: [ :create, :index ], path: :members
      end

      resources :event_members, only: [ :show, :update ]

      get :hello, to: "auth#hello"
    end

    namespace :v1 do
      namespace :admin do
        resources :events, only: [:index, :show] do
          collection do
            get :review, to: "events#review"
          end

          member do
            put :review, to: "events#update_review"
          end
        end
        resources :event_members, only: [:update, :destroy]
      end
    end
  end
end
