require 'rails_helper'

RSpec.describe IngredientsController, type: :controller do
  before(:each) do
    @other_user = create(:user)
    @test_user = create(:user)
    sign_in @test_user
  end

  describe "index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "filters on ingredients for the current user" do
      @ingredient = class_double('Ingredient').as_stubbed_const
      allow(@ingredient).to receive(:where).and_return(@ingredient)

      expect(@ingredient).to receive(:where)
                        .with(any_args, hash_including(user_id: @test_user.id))
      get :index
      expect(response).to be_successful
    end
  end

  describe "update" do
    it "Redirects to ingredient show page after successful update" do
      @ingredient = create(:ingredient, user_id: @test_user.id)
      put :update, params: { 'id' => @ingredient.id, 'ingredient' => { name: 'Changed Ingredient' } }
      expect(response).to redirect_to(ingredient_path(@ingredient.id))
    end
  end
end