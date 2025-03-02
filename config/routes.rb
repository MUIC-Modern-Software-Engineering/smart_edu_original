Rails.application.routes.draw do
  get "teachers/index"
  get "teachers/destroy"
  resources :classrooms, only: [ :index, :show ]

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
  resources :attendances

  get "/students/scan", to: "admin#scan_qr"
  resources :attendances
  resources :students do
    collection do
      post "mark_attendance"
    end
  end

  get "home/index"
  resource :session
  # resources :sessions
  resources :passwords, param: :token
  resources :signup, only: %i[new create]
  resources :users, only: %i[index] do
    member do
      patch :approve
      # delete :destroy
    end
  end

  get "login", to: "sessions#new", as: "login"
  # post "sessions", to: "sessions#create"
  # delete "sessions", to: "sessions#destroy"

  get "/admin/scan_qr", to: "admin#scan_qr"
  post "/admin/checkin", to: "admin#checkin"
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  resources :students do
    member do
      patch :toggle_status
      patch :archive
      patch :activate
    end
    collection do
      get :manage  # This will map to students#manage
    end
  end
  get "classrooms/:id/grades/:grade", to: "classrooms#grading", as: :grading_by_grade
  get "grades/:grade", to: "classrooms#by_grade", as: :grade

  resources :teachers, only: [ :index, :destroy ]
  resources :users, only: [ :index, :destroy ]
end
