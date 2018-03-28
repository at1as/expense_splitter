Rails.application.routes.draw do
  resources :events do
    resources :people
    resources :expenses
  end
end
