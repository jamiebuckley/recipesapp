class AddQuantitiesAndOriginsToShoppingListIngredients < ActiveRecord::Migration[7.0]
  def change
    add_column :shopping_list_ingredients, :quantity, :float, null: false
    add_column :shopping_list_ingredients, :unit, :string, null: false
    add_reference :shopping_list_ingredients, :recipe_ingredient, null: true, foreign_key: true
  end
end
