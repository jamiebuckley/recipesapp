class ProfileController < ApplicationController

  REGEX_PATTERN = /^(.+)@(.+)$/

  def index
    @recipe_shares = current_user.owned_shares
    @incoming_shares = current_user.received_shares
    @user_recipes_share = UserRecipesShare.new(owner: current_user)
  end

  def add_user_recipe_share
    @recipe_shares = current_user.owned_shares
    @user_recipes_share = UserRecipesShare.new(owner: current_user)
    permitted = params.require(:user_recipes_share).permit(:share_email)

    if @user_recipes_share.update(permitted)
      flash[:success] = "Invite has been sent to #{@user_recipes_share.share_email}"
      redirect_to profile_index_path
    else
      render :index, status: :unprocessable_entity
    end
  end
end
