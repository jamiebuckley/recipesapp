class ShoppingListAdditionalItemsController < ApplicationController

  protect_from_forgery unless: -> { request.format.json? }

  def create
    @shopping_list = ShoppingList.for_current_user(current_user.id).where(complete: false).first
    shopping_list_item = ShoppingListAdditionalItem.create(shopping_list:@shopping_list, name: params[:name], category: params[:category])
    render :json => shopping_list_item
  end
end