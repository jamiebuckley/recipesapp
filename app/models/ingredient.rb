class Ingredient < ApplicationRecord
  validates :name, presence: true

  scope :for_current_user, ->(user_id) { where(user_id: user_id) }
end
