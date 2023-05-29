class RecipeTag < ApplicationRecord
  belongs_to :recipe

  scope :for_current_user, ->(user_id) { joins(:recipe).where({ recipe: { user_id: user_id }}) }

  scope :for_current_user_or_shared, ->(user_id) {
    joins(:recipe)
      .where({
               recipe: {
                 user_id: user_id }
             })
      .or(where({
                  recipe: {
                    user_id: UserRecipesShare.where(accepted: true, recipient_id: user_id).select("owner_id")
                  }
                })
      )}
end