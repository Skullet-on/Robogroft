Rails.application.routes.draw do
  devise_for :users
  resources :users

  resources :vms

  #resources :tasks

  root to: "users#index"

  post "upload" => 'tasks#upload'
  
  resources :tasks do
  	collection do
  		get 'pending'
      get 'current'
  	end
  end

end
