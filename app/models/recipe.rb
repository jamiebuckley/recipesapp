class Recipe < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_name, against: :name, using: {
    tsearch: { prefix: true }
  }

  belongs_to :user

  validates :name, presence: true

  has_many :recipe_ingredients, -> { order(position: :asc) }, :dependent => :delete_all
  has_many :recipe_steps, -> { order(position: :asc) }, :dependent => :delete_all

  has_many :ingredients, through: :recipe_ingredients

  scope :for_current_user, ->(user_id) { where(user_id: user_id) }

  has_one_attached :image
end
