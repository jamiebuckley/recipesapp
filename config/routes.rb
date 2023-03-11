Rails.application.routes.draw do
  get 'profile/index'
  post 'profile/add_user_recipe_share'

  resources :user_recipes_shares
  post 'user_recipes_shares/:share_id/accept', to: 'user_recipes_shares#accept', as: 'accept_incoming_user_recipes_share'
  delete 'user_recipes_shares/:share_id/cancel', to: 'user_recipes_shares#cancel', as: 'cancel_user_recipes_share'

  resources :recipes do
    resources :recipe_ingredients, as: :ingredients, path: :ingredients
    resources :recipe_steps, as: :steps, path: :steps
  end

  resources :ingredients
  resources :shopping_lists

  resources :shopping_list_additional_items, only: :create

  get '/ingredients/search/:search_term', to: 'ingredients#search', as: 'ingredients_search'
  post '/recipes/:recipe_id/add_to_list', to: 'recipes#add_to_list', as: 'recipe_add_to_list'

  get '/shopping_lists/:share_code', to: 'shopping_lists#show', as: 'shopping_list_by_code'

  delete '/shopping_lists/:shopping_list_id/recipes/:recipe_id', to: 'shopping_lists#remove_recipe', as: 'remove_recipe_from_shopping_list'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "recipes#index"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
