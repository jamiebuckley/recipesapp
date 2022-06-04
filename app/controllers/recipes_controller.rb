class RecipesController < ApplicationController

  def index
    @user_recipes = Recipe.where(user_id: current_user.id)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    permitted  = params.require(:recipe).permit(:name)
    @recipe = Recipe.new(permitted)
    @recipe.user_id = current_user.id
    if @recipe.save
      redirect_to @recipe
    else
      render :new, status: 422
    end
  end
end
