require 'securerandom'

class RecipesController < ApplicationController
  def index
    @tags = RecipeTag.for_current_user_or_shared(current_user.id).pluck(:tag).uniq
    @inbound_sharers = UserRecipesShare.where(accepted: true, recipient_id: current_user.id)
    @current_shopping_list = ShoppingList.for_current_user(current_user.id).where(complete: false).first
    if !@current_shopping_list.nil?
      @used_recipes = @current_shopping_list.shopping_list_ingredients.map {|i| i.recipe_ingredient.recipe_id }.uniq
    else
      @used_recipes = []
    end
    @search_term = params[:search]

    # select * from recipes where user_id = '845781420561498113'
    # or user_id in (select urs.owner_id from user_recipes_shares urs
    # where urs.accepted = true and urs.recipient_id = '845781420561498113');


    if params[:source]
      if params[:source].has_key? "mine" and params[:source].keys.count == 1
        @user_recipes = Recipe.for_current_user(current_user.id)
      elsif !params[:source].has_key? "mine" and params[:source].keys.count > 0
        @user_recipes = Recipe.shared_by(current_user.id, params[:source].keys)
      else
        @user_recipes = Recipe.for_current_user_or_shared_by(current_user.id, params[:source].keys)
      end
    else
      @user_recipes = Recipe.for_current_user_or_shared(current_user.id)
    end
    @user_recipes = @user_recipes.joins(:user).left_joins(:recipe_tags)

    if params[:search]
      search_string = params[:search].downcase
      unless search_string.blank?
        @user_recipes = @user_recipes.where("lower(name) LIKE :prefix", prefix: "#{search_string}%")
      end
    end

    if params[:tags]
      @user_recipes = @user_recipes.where('recipe_tags.tag in (?)', params[:tags].keys)
    end

    @user_recipes = @user_recipes.uniq
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
    @recipe = Recipe.for_current_user_or_shared(current_user.id).where(id: params[:id])
                    .left_joins(:recipe_ingredients => :ingredient).order(position: :desc)
                    .first
    if @recipe.nil?
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end

  def edit
    @recipe = Recipe.for_current_user(current_user.id).find_by(id: params[:id])
    if @recipe.nil?
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end

  def update
    permitted  = params.require(:recipe).permit(:name, :image)
    @recipe = Recipe.for_current_user(current_user.id).find(params[:id])
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
    @recipe = Recipe.for_current_user_or_shared(current_user.id).find(params[:recipe_id])
    @shopping_list = ShoppingList.for_current_user(current_user.id).where(complete: false).first
    if @shopping_list.nil?
      @shopping_list = ShoppingList.create(user: current_user, complete: false, share_code: SecureRandom.uuid.to_s)
    end

    existing_ingredients = @shopping_list.shopping_list_ingredients.to_a

    @recipe.recipe_ingredients.each do |recipe_ingredient|
      next if existing_ingredients.select { |i| i.recipe_ingredient_id == recipe_ingredient.id }.any?
      shopping_list_ingredient = ShoppingListIngredient.create(shopping_list: @shopping_list,
                                                               ingredient_id: recipe_ingredient.ingredient_id,
                                                               quantity: recipe_ingredient.quantity,
                                                               unit: recipe_ingredient.unit,
                                                               recipe_ingredient_id: recipe_ingredient.id)

    end
    @shopping_list.save!

    respond_to do |format|
      format.html do
        flash[:success] = "Added #{@recipe.name} to list"
        redirect_to recipes_path
      end
      format.turbo_stream do

      end
    end
  end

  def remove_from_list
    @recipe = Recipe.for_current_user_or_shared(current_user.id).find(params[:recipe_id])
    @shopping_list = ShoppingList.for_current_user(current_user.id).where(complete: false).first
    items_to_remove = @shopping_list.shopping_list_ingredients.select {|sli| sli.recipe_ingredient.recipe_id == params[:recipe_id].to_i}
    items_to_remove.each do |i|
      i.destroy
    end

    respond_to do |format|
      format.html do
        redirect_to recipes_path
      end
      format.turbo_stream do

      end
    end
  end

  def add_tag
    @recipe = Recipe.for_current_user_or_shared(current_user.id).find(params[:recipe_id])
    if @recipe.recipe_tags.any? { |recipe_tag| recipe_tag.tag == params[:tag] }
      return
    end

    @recipe.recipe_tags.push RecipeTag.create(recipe: @recipe, tag: params[:tag])
    respond_to do |format|
      format.turbo_stream do

      end
    end
  end

  def remove_tag
    @recipe = Recipe.for_current_user_or_shared(current_user.id).find(params[:recipe_id])
    tags = @recipe.recipe_tags.where(id: params[:tag_id].to_i)
    tags.destroy_all
  end

  def destroy
    recipe = Recipe.for_current_user(current_user.id).find(params[:id])
    recipe.destroy
    redirect_to recipes_path
  end
end
