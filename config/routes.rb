Rails.application.routes.draw do
  resources :recipes
  get '/recipes/:id/ingredients', to: 'recipe_ingredients#index', as: 'recipe_ingredients'
  post '/recipes/:id/ingredients', to: 'recipe_ingredients#create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "recipes#index"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
