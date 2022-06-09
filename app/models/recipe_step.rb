class RecipeStep < ApplicationRecord
  belongs_to :recipe

  acts_as_list scope: :recipe
end
