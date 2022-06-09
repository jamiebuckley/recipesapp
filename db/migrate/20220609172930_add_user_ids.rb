class AddUserIds < ActiveRecord::Migration[7.0]
  def change
    add_column :recipe_steps, :user_id, :integer
    add_column :recipe_ingredients, :user_id, :integer
    add_column :ingredients, :user_id, :integer
  end
end
