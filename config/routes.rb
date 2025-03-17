Rails.application.routes.draw do
  get "payments/new"
  get "payments/create"
  get "teachers/index"
  get "teachers/destroy"
  resources :classrooms, only: [ :index, :show ]
  root "main#index"
  get "main/index"

  resources :payments  do
  collection do
    get "success", to: "payments#success"
    get "cancel", to: "payments#cancel"
  end
  end
  resources :classrooms do
    collection do
      get "by_grade/:grade", to: "classrooms#by_grade", as: "by_grade"
    end
    member do
      get :grading
      get :grade_level
    end
    resources :students, only: [ :index, :show ]
  end

  # Attendances Routes
  resources :attendances do
    collection do
      get "scan_qr", to: "attendances#scan_qr", as: "scan_qr"
      post "checkin", to: "attendances#checkin"
    end
  end

  resources :attendances, only: [ :create ] do
    get "/status", to: "attendances#status"
  end

  # Profile Routes
  get "profile", to: "profile#show"
  post "/change_password", to: "users#change_password"
  resource :profile, only: [ :show, :update ]
  patch "/profile/update_password", to: "profile#update_password"

  # Students
  resources :students do
    collection do
      post "mark_attendance"
    end
  end

  # Other Routes
  get "home/index"
  get "logout", to: "sessions#destroy", as: :logout
  resource :session,  only: [ :new, :create, :destroy ]
  resources :passwords, param: :token
  resources :signup, only: %i[ new create ]
  resources :users, only: %i[ index ] do
    member do
      patch :approve
    end
  end

  get "login", to: "sessions#new", as: "login"
  get "up" => "rails/health#show", as: :rails_health_check

  # Additional Student Actions
  resources :students do
    member do
      patch :toggle_status
      patch :archive
      patch :activate
    end
    collection do
      get :manage
    end
  end

  get "classrooms/:id/grades/:grade", to: "classrooms#grading", as: :grading_by_grade
  get "grades/:grade", to: "classrooms#by_grade", as: :grade

  # Teachers & Users
  resources :teachers, only: [ :index, :destroy ]
  resources :users, only: [ :index, :destroy ]
end
