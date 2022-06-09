class RecipeStepsController < ApplicationController

  def set_values(id)
    @recipe = Recipe.for_current_user(current_user.id).find(id)
  end

  def index
    set_values(params[:recipe_id])
    @new_recipe_step = RecipeStep.new()
  end

  def create
    set_values(params[:recipe_id])

    permitted  = params.require(:recipe_step).permit(:instructions)
    @new_recipe_step = RecipeStep.new(recipe_id: params[:recipe_id], instructions: permitted[:instructions], user_id: current_user.id)

    if @new_recipe_step.valid? && @new_recipe_step.save
      redirect_to recipe_steps_path(params[:recipe_id])
    else
      render :index, status: 422
    end
  end

  def update
    set_values(params[:recipe_id])
    permitted = params.require(:recipe_step).permit(:position, :instructions)
    @new_recipe_step = RecipeStep.find(params[:id])
    @new_recipe_step.update(permitted)
    redirect_to recipe_steps_path(params[:recipe_id])
  end

  def show
    set_values(params[:recipe_id])
    @new_recipe_step = RecipeStep.find(params[:id])
  end

  def destroy
    set_values(params[:recipe_id])
    recipe_step = @recipe.recipe_steps.find { |i| i.id == params[:id].to_i }
    recipe_step.destroy
    redirect_to recipe_steps_path(params[:recipe_id])
  end
end
