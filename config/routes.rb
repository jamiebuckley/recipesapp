Rails.application.routes.draw do
  resources :recipes do
    resources :recipe_ingredients, as: :ingredients, path: :ingredients
  end

  get '/ingredients/:search_term', to: 'ingredients#search', as: 'ingredients_search'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "recipes#index"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
