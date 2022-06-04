class RecipeIngredientsController < ApplicationController

  def set_values(id)
    @recipe = Recipe.where(id: params[:id], user_id: current_user.id)
          .left_joins(:recipe_ingredients => :ingredient)
          .first
    @unit_options = ['Kilograms', 'Grams', 'Litres', 'Millilitres', 'Tablespoons', 'Teaspoons', 'Cups', 'Pinches', 'Items']
  end

  def index
    set_values(params[:id])

    @recipe_ingredient = RecipeIngredient.new(recipe_id: params[:id])
    @recipe_ingredient.ingredient = Ingredient.new()
  end

  def create
    set_values(params[:id])

    permitted  = params.require(:recipe_ingredient).permit(:quantity, :unit, :ingredient => :name)
    @recipe_ingredient = RecipeIngredient.new(recipe_id: params[:id], quantity: permitted[:quantity], unit: permitted[:unit])
    @recipe_ingredient.ingredient = Ingredient.new(name: params[:recipe_ingredient][:ingredient][:name])

    @recipe_ingredient.valid?
    @recipe_ingredient.ingredient.valid?

    if @recipe_ingredient.valid? && @recipe_ingredient.ingredient.valid? && @recipe_ingredient.save
      redirect_to recipe_ingredients_path(params[:id])
    else
      render :index, status: 422
    end
  end
end
