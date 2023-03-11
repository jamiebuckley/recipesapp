class ShoppingList < ApplicationRecord
  belongs_to :user

  scope :for_current_user, ->(user_id) { where(user_id: user_id) }

  has_many :shopping_list_ingredients
  has_many :ingredients, through: :shopping_list_ingredients
  has_many :shopping_list_additional_items
end
