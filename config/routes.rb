Rails.application.routes.draw do
  root 'events#index'
  
  resources :events do
    resources :people
    resources :expenses
  end
end
