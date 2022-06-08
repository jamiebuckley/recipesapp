class Recipe < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  has_many :recipe_ingredients, -> { order(position: :asc) }

  scope :for_current_user, ->(user_id) { where(user_id: user_id) }
end
