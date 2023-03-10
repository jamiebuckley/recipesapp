class RecipeIngredient < ApplicationRecord
  belongs_to :ingredient
  belongs_to :recipe

  validates :quantity, presence: true
  validates :unit, presence: true

  has_many :shopping_list_ingredients, dependent: :destroy

  acts_as_list scope: :recipe

  scope :for_current_user, ->(user_id) { where(user_id: user_id) }
end
