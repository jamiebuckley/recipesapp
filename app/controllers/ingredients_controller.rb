class IngredientsController < ApplicationController
  def search
    ingredients = Ingredient
      .where("lower(name) like lower(:prefix)", prefix: "#{params[:search_term]}%")
                    .select(:name).distinct.map { |i| i.name }
    render :json => ingredients
  end
end
