class ShoppingListIngredient < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :ingredient
  belongs_to :recipe_ingredient

end
