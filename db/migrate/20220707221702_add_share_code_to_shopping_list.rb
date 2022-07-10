class AddShareCodeToShoppingList < ActiveRecord::Migration[7.0]
  def change
    add_column :shopping_lists, :share_code, :string, null: false
  end
end
