class AddCompleteToShoppingListIngredient < ActiveRecord::Migration[7.0]
  def change
    add_column :shopping_list_ingredients, :complete, :boolean, null: false, default: false
  end
end
