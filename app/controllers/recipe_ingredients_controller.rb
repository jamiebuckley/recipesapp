class RecipeIngredientsController < ApplicationController

  def set_values(id)
    @recipe = Recipe.for_current_user(current_user.id).find(id)
    @unit_options = %w[g kg ml l tbsp tsp cup pinch items]
  end

  def index
    set_values(params[:recipe_id])

    @recipe_ingredient = RecipeIngredient.new(recipe_id: params[:id])
    @recipe_ingredient.ingredient = Ingredient.new()

    respond_to do |format|
      format.html
      format.json do
        render json: @recipe.recipe_ingredients.map { |recipe_ingredient|
          {
            id: recipe_ingredient.id.to_s,
            position: recipe_ingredient.position,
            name: recipe_ingredient.ingredient.name,
            quantity: recipe_ingredient.quantity,
            unit: recipe_ingredient.unit
          }
        }

      end
    end
  end

  def create
    set_values(params[:recipe_id])

    permitted = params.require(:recipe_ingredient).permit(:quantity, :unit, :ingredient => :name)
    @recipe_ingredient = RecipeIngredient.new(recipe_id: params[:recipe_id], quantity: permitted[:quantity], unit: permitted[:unit], user_id: current_user.id)

    @recipe_ingredient.ingredient = Ingredient.where(:name => params[:recipe_ingredient][:ingredient][:name], :user_id => current_user.id)
                                              .first_or_create
    @recipe_ingredient.valid?
    @recipe_ingredient.ingredient.valid?

    respond_to do |format|
      format.html do
        if @recipe_ingredient.valid? && @recipe_ingredient.ingredient.valid? && @recipe_ingredient.save
          redirect_to recipe_ingredients_path(params[:recipe_id])
        else
          render :index, status: 422
        end
      end
      format.json do
        if @recipe_ingredient.valid? && @recipe_ingredient.ingredient.valid? && @recipe_ingredient.save
        render json: {
            id: @recipe_ingredient.id.to_s,
            position: @recipe_ingredient.position,
            name: @recipe_ingredient.ingredient.name,
            quantity: @recipe_ingredient.quantity,
            unit: @recipe_ingredient.unit
          }
        else
          render json: {

          }, status: 400
        end
      end
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

    respond_to do |format|
        format.html do
          redirect_to recipe_ingredients_path(params[:recipe_id])
        end
        format.json do
          head :ok
        end
      end
  end
end
