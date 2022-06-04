class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.timestamps
      t.references :user, foreign_key: true, null: false
    end
  end
end
