class CreateUserRecipesShares < ActiveRecord::Migration[7.0]
  def change
    create_table :user_recipes_shares do |t|
      t.text :share_email, null: false

      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: true, foreign_key: { to_table: :users }
      t.timestamps
      t.boolean :accepted
    end
  end
end
