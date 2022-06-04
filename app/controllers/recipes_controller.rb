class RecipesController < ApplicationController

  def index
    @user_recipes = Recipe.find_by_user_id(current_user.id)
  end
end
