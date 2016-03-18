Rails.application.routes.draw do
  get 'pages/home'

  devise_for :users
  resources :users

  resources :vms

  #resources :tasks

  #root to: "users#index"
  root to: "pages#home"

  post "upload" => 'tasks#upload'

  resources :tasks do
  	collection do
  		get 'pending'
      get 'current'
  	end
  end

end
