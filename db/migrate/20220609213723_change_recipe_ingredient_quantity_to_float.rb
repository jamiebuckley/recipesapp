class ChangeRecipeIngredientQuantityToFloat < ActiveRecord::Migration[7.0]
  def change
    change_column :recipe_ingredients, :quantity, :float, using: 'quantity::float'
  end
end
