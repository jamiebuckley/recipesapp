class AddPositionToRecipeSteps < ActiveRecord::Migration[7.0]
  def change
    add_column :recipe_steps, :position, :integer
  end
end
