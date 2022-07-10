Rails.application.routes.draw do
  resources :recipes do
    resources :recipe_ingredients, as: :ingredients, path: :ingredients
    resources :recipe_steps, as: :steps, path: :steps
  end

  resources :ingredients
  resources :shopping_lists

  get '/ingredients/search/:search_term', to: 'ingredients#search', as: 'ingredients_search'
  post '/recipes/:recipe_id/add_to_list', to: 'recipes#add_to_list', as: 'recipe_add_to_list'

  get '/shopping_lists/:share_code', to: 'shopping_lists#show', as: 'shopping_list_by_code'

  delete '/shopping_lists/:shopping_list_id/recipes/:recipe_id', to: 'shopping_lists#remove_recipe', as: 'remove_recipe_from_shopping_list'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "recipes#index"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
