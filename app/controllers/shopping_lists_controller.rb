class ShoppingListsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:show]

  def create_groups
    @groups = @shopping_list.shopping_list_ingredients
                            .to_a.group_by {|i| i.ingredient.category.blank? ? 'Ungrouped' : i.ingredient.category }

    @additional_items_groups = @shopping_list.shopping_list_additional_items
                                 .to_a.group_by {|i| i.category.blank? ? 'Ungrouped' : i.category }


    @groups = @groups.map do |group|
      values = group[1]
      values_reduced = values.reduce({}) { |acc, item|
        this_key = item.ingredient_id.to_s + "_" + item.unit
        if acc.key? this_key
          acc[this_key].quantity += item.quantity
        else
          acc[this_key] = item
        end
        acc
      }
      [group[0],  values_reduced.values]
    end
    @groups = @groups.each_with_object({}) do |i, my_hash| my_hash[i[0]] = i[1] end
    @groups = @groups.deep_merge(@additional_items_groups)
  end

  def to_json_hash(shopping_list, groups)
    hash_result = { id: shopping_list.id.to_s }
    hash_result["groups"] = groups.map do |group|
      group_result = {}
      group_result["name"] = group[0]
      group_result["items"] = group[1].map do |group_item|
        group_item_result = {}
        group_item_result["id"] = group_item.id

        if group_item.instance_of? ShoppingListAdditionalItem
          group_item_result["name"] = group_item.name
        end

        if group_item.instance_of? ShoppingListIngredient
          group_item_result["name"] = group_item.ingredient.name
          group_item_result["quantity"] = "#{group_item.quantity.to_s.sub(/\.?0+$/, '')} #{group_item["unit"]}"
        end
        group_item_result
      end
      group_result
    end

    hash_result
  end

  def index
    @shopping_list = ShoppingList.for_current_user(current_user.id).where(complete: false).first
    if @shopping_list.nil?
      return
    end

    create_groups

    respond_to do |format|
      format.html do
        render :index
      end
      format.json do
        render :json => to_json_hash(@shopping_list, @groups)
      end
    end
  end

  def edit
    @shopping_list = ShoppingList.for_current_user(current_user.id).where(complete: false).first
    @used_recipes = @shopping_list.shopping_list_ingredients.map {|i| i.recipe_ingredient.recipe }.uniq
  end

  def show
    share_code = params['id']
    @shopping_list = ShoppingList.where(share_code: share_code).first
    if @shopping_list.nil?
      render 'index'
      return
    end
    create_groups

    render 'index'
  end

  def remove_recipe
    @shopping_list = ShoppingList
                       .for_current_user(current_user.id)
                       .find(params[:shopping_list_id])
    if @shopping_list.nil?
      return
    end

    items_to_remove = @shopping_list.shopping_list_ingredients.select {|sli| sli.recipe_ingredient.recipe_id == params[:recipe_id].to_i}
    items_to_remove.each do |i|
      i.destroy
    end
    redirect_to edit_shopping_list_path(@shopping_list)
  end


  def destroy
    params.permit(:id, :share_code)
    @shopping_list = ShoppingList
                       .for_current_user(current_user.id)
                       .find(params[:id])
    @shopping_list.complete = true
    @shopping_list.save
    redirect_to shopping_lists_path, status: 303
  end
end