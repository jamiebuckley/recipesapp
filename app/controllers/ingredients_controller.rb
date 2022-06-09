class IngredientsController < ApplicationController
  def search
    ingredients = Ingredient
      .where(user_id: current_user.id)
      .where("lower(name) like lower(:prefix)", prefix: "#{params[:search_term]}%")
                    .select(:name).distinct.map { |i| i.name }
    render :json => ingredients
  end

  def index
    @ingredients = Ingredient.where(user_id: current_user.id)
  end

  def show
    @ingredient = Ingredient.where(user_id: current_user.id).find(params[:id])
    @recipes = Recipe.for_current_user(current_user.id).joins(recipe_ingredients: :ingredient).where(recipe_ingredients: { ingredients: { id: params[:id] }})
  end
end
