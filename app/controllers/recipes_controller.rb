class RecipesController < ApplicationController

  def index
    @search_term = params[:search]
    @user_recipes = Recipe.where(user_id: current_user.id)
    if params[:search]
      @user_recipes = @user_recipes.search_name(params[:search])
    end
  end

  def new
    @recipe = Recipe.new
  end

  def create
    permitted  = params.require(:recipe).permit(:name)
    @recipe = Recipe.new(permitted)
    @recipe.user_id = current_user.id
    if @recipe.save
      redirect_to recipe_path(id: @recipe.id)
    else
      render :new, status: 422
    end
  end

  def show
    @recipe = Recipe.where(id: params[:id], user_id: current_user.id)
                    .left_joins(:recipe_ingredients => :ingredient).order(position: :desc)
                    .first
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    permitted  = params.require(:recipe).permit(:name, :image)
    @recipe = Recipe.find(params[:id])
    if @recipe.update(permitted)
      if permitted[:image]
        @recipe.image.attach(permitted[:image])
      end

      redirect_to recipe_ingredients_path(recipe_id: @recipe.id)
    else
      render :edit, status: 422
    end
  end

  def destroy
    recipe = Recipe.for_current_user(current_user.id).find(params[:id])
    recipe.destroy
    redirect_to recipes_path
  end
end
