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
      redirect_to recipe_ingredients_path(id: @recipe.id)
    else
      render :new, status: 422
    end
  end

  def show
    @recipe = Recipe.where(id: params[:id], user_id: current_user.id)
                    .left_joins(:recipe_ingredients => :ingredient)
                    .first
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    permitted  = params.require(:recipe).permit(:name)
    @recipe = Recipe.find(params[:id])
    if @recipe.update(permitted)
      redirect_to recipe_ingredients_path(id: @recipe.id)
    else
      render :edit, status: 422
    end
  end
end
