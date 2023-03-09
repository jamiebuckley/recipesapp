class UserRecipesSharesController < ApplicationController

  def create
    @user_recipes_share = UserRecipesShare.create(params.require(:user_recipes_share).permit(:share_email)) do |share|
      share.owner = current_user
    end

    respond_to do |format|
      format.html do
        if @user_recipes_share.valid?
          redirect_to profile_index_path
        else
          @recipe_shares = current_user.owned_shares
          @incoming_shares = current_user.received_shares
          render "profile/index", status: :unprocessable_entity
        end
      end

      format.turbo_stream do
        if @user_recipes_share.valid?
          @created_user_recipes_share = @user_recipes_share
          @user_recipes_share = UserRecipesShare.new()
        else
          @created_user_recipes_share = nil
          render status: :unprocessable_entity
        end
      end
    end
  end

  def accept
    share_id = params[:share_id]
    incoming_share = UserRecipesShare.find_by(recipient_id: current_user.id, id: share_id)
    incoming_share.update(accepted: true)

    respond_to do |format|
      format.html do
        if !incoming_share.valid?
          flash[:error] = "Failed to accept incoming share"
        end
        redirect_to profile_index_path
      end

      format.turbo_stream do
        @updated_recipes_share = incoming_share
        if !incoming_share.valid?
          render status: :unprocessable_entity
        end
      end
    end
  end

  def cancel
    share_id = params[:share_id]
    cancelled_share = UserRecipesShare.find_by(id: share_id)
    if !cancelled_share.nil? && cancelled_share.can_destroy?(current_user)
      cancelled_share.destroy
    end
    respond_to do |format|
      format.html do
        redirect_to profile_index_path
      end

      format.turbo_stream do
        @cancelled_recipes_share = cancelled_share
      end
    end
  end
end