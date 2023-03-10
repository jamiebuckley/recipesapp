require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  before(:each) do
    @other_user = create(:user)
    @test_user = create(:user)
    sign_in @test_user
  end

  describe "index" do
    it "displays a users owned and shared recipes" do
      Recipe.create(user: @other_user, name: "Recipe1")
      Recipe.create(user: @test_user, name: "Recipe2")
      UserRecipesShare.create(owner: @other_user, recipient: @test_user, share_email: @test_user.email, accepted: true)

      get :index
      expect(response).to be_successful
      expect(controller.instance_variable_get(:@user_recipes).count).to eq(2)
    end

    it "does not display recipes that have not been shared with the user" do
      third_user = create(:user)
      Recipe.create(user: third_user, name: "Recipe3")
      Recipe.create(user: @test_user, name: "Recipe4")

      get :index
      expect(response).to be_successful
      expect(controller.instance_variable_get(:@user_recipes).count).to eq(1)
    end

    it "does not allow editing recipes that do not below to the current user" do
      recipe_1 = Recipe.create(user: @other_user, name: "Recipe1")
      recipe_2 = Recipe.create(user: @test_user, name: "Recipe2")
      UserRecipesShare.create(owner: @other_user, recipient: @test_user, share_email: @test_user.email, accepted: true)

      get :edit, params: { id: recipe_1.id }
      expect(response).to be_not_found
    end
  end
end