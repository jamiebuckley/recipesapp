require 'rails_helper'

RSpec.describe UserRecipesSharesController, type: :controller do
  before(:each) do
    @other_user = create(:user)
    @test_user = create(:user)
    sign_in @test_user
  end

  describe "create" do
    it "Redirects to profile index page when model creation is successful" do
      post :create, params: { 'user_recipes_share' => { 'share_email': 'test@email.com' } }
      expect(response).to redirect_to(profile_index_path)
    end

    it "Returns 422 unprocessable when model creation is not successful" do
      post :create, params: { 'user_recipes_share' => { 'share_email': 'NOT_VALID' } }
      expect(response).to be_unprocessable
    end
  end

end