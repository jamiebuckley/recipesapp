class ShoppingListsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def create_groups
    @groups = @shopping_list.shopping_list_ingredients
                            .to_a.group_by {|i| i.ingredient.category.blank? ? 'Ungrouped' : i.ingredient.category }

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
  end

  def index
    @shopping_list = ShoppingList.for_current_user(current_user.id).where(complete: false).first
    if @shopping_list.nil?
      return
    end

    create_groups
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

  def destroy
    params.permit(:id, :share_code)
    @shopping_list = ShoppingList
                       .for_current_user(current_user.id)
                       .find(params[:id])
    @shopping_list.complete = true
    @shopping_list.save
    redirect_to recipes_path
  end
end