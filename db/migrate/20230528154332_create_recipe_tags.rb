class CreateRecipeTags < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_tags do |t|
      t.references :recipe, null: false, foreign_key: true
      t.column :tag, :string
      t.timestamps
    end
  end
end
