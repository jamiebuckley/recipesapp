require 'securerandom'

class RecipesController < ApplicationController
  def index
    current_shopping_list = ShoppingList.for_current_user(current_user.id).where(complete: false).first
    if !current_shopping_list.nil?
      @used_recipes = current_shopping_list.shopping_list_ingredients.map {|i| i.recipe_ingredient.recipe_id }.uniq
    else
      @used_recipes = []
    end
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
        path = permitted[:image].tempfile.path
        image = ImageProcessing::Vips.source(path)
        result = image.resize_to_limit!(400, 300)
        permitted[:image].tempfile = result
        @recipe.image.attach(permitted[:image])
      end

      redirect_to recipe_ingredients_path(recipe_id: @recipe.id)
    else
      render :edit, status: 422
    end
  end

  def add_to_list
    recipe = Recipe.for_current_user(current_user.id).find(params[:recipe_id])
    shopping_list = ShoppingList.for_current_user(current_user.id).where(complete: false).first
    if shopping_list.nil?
      shopping_list = ShoppingList.create(user: current_user, complete: false, share_code: SecureRandom.uuid.to_s)
    end

    existing_ingredients = shopping_list.shopping_list_ingredients.to_a

    recipe.recipe_ingredients.each do |recipe_ingredient|
      next if existing_ingredients.select { |i| i.recipe_ingredient_id == recipe_ingredient.id }.any?
      shopping_list_ingredient = ShoppingListIngredient.create(shopping_list: shopping_list,
                                                               ingredient_id: recipe_ingredient.ingredient_id,
                                                               quantity: recipe_ingredient.quantity,
                                                               unit: recipe_ingredient.unit,
                                                               recipe_ingredient_id: recipe_ingredient.id)
      shopping_list.shopping_list_ingredients

      flash[:success] = "Added #{recipe.name} to list"
    end
    shopping_list.save!
    redirect_to recipes_path
  end

  def destroy
    recipe = Recipe.for_current_user(current_user.id).find(params[:id])
    recipe.destroy
    redirect_to recipes_path
  end
end
