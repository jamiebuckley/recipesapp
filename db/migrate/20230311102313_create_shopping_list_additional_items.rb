class CreateShoppingListAdditionalItems < ActiveRecord::Migration[7.0]
  def change
    create_table :shopping_list_additional_items do |t|
      t.string :name
      t.references :shopping_list, null: false, foreign_key: true
      t.string :category

      t.timestamps
    end
  end
end
