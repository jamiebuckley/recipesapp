class IngredientsController < ApplicationController
  def search
    ingredients = Ingredient
      .where("lower(name) like lower(:prefix)", prefix: "#{params[:search_term]}%")
                    .select(:name).distinct.map { |i| i.name }
    render :json => ingredients
  end

  def index
    @ingredients = Ingredient.all
  end

  def show
    @ingredient = Ingredient.find(params[:id])
    @recipes = Recipe.joins(recipe_ingredients: :ingredient).where(recipe_ingredients: { ingredients: { id: params[:id] }})
  end
end
