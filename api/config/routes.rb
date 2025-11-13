Rails.application.routes.draw do
  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine => "/api-docs"

  get "up" => "rails/health#show", as: :rails_health_check

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

        resources :event_members, only: [ :create, :index ], path: :members do
          get :reviews, on: :collection
        end

        resources :organizers, only: [ :create, :destroy ], controller: "event_organizers", param: :user_id
      end

      resources :event_members, only: [ :show, :update ]

      get :hello, to: "auth#hello"
    end
  end
end
