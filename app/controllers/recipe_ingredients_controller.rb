class RecipeIngredientsController < ApplicationController

  def set_values(id)
    @recipe = Recipe.for_current_user(current_user.id).find(id)
    @unit_options = %w[g kg ml l tbsp tsp cup pinch items]
  end

  def index
    set_values(params[:recipe_id])

    @recipe_ingredient = RecipeIngredient.new(recipe_id: params[:id])
    @recipe_ingredient.ingredient = Ingredient.new()
  end

  def create
    set_values(params[:recipe_id])

    permitted  = params.require(:recipe_ingredient).permit(:quantity, :unit, :ingredient => :name)
    @recipe_ingredient = RecipeIngredient.new(recipe_id: params[:recipe_id], quantity: permitted[:quantity], unit: permitted[:unit], user_id: current_user.id)

    @recipe_ingredient.ingredient = Ingredient.where(:name => params[:recipe_ingredient][:ingredient][:name], :user_id => current_user.id)
                                              .first_or_create
    @recipe_ingredient.valid?
    @recipe_ingredient.ingredient.valid?

    if @recipe_ingredient.valid? && @recipe_ingredient.ingredient.valid? && @recipe_ingredient.save
      redirect_to recipe_ingredients_path(params[:recipe_id])
    else
      render :index, status: 422
    end
  end

  def update
    set_values(params[:recipe_id])
    permitted = params.require(:recipe_ingredient).permit(:position)
    @recipe_ingredient = RecipeIngredient.for_current_user(current_user.id).find(params[:id])
    @recipe_ingredient.update(permitted)
  end

  def destroy
    @recipe_ingredient = RecipeIngredient.for_current_user(current_user.id).find(params[:id])
    @recipe_ingredient.destroy
    redirect_to recipe_ingredients_path(params[:recipe_id])
  end
end
