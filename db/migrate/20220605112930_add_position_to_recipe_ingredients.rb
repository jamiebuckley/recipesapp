class AddPositionToRecipeIngredients < ActiveRecord::Migration[7.0]
  def change
    add_column :recipe_ingredients, :position, :integer
  end
end
