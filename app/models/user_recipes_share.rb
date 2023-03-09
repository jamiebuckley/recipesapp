class UserRecipesShare < ApplicationRecord
  REGEX_PATTERN = /\A(.+)@(.+)\z/

  belongs_to :owner, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User', optional: true

  validates :share_email, presence: true, uniqueness: { scope: :owner }
  validates :share_email, format: { with: REGEX_PATTERN }

  before_create :populate_recipient
  before_update :populate_recipient, :if => :share_email_changed?

  def populate_recipient
    self.recipient = User.find_by_email(self.share_email)
  end

  def can_destroy?(current_user)
    self.recipient == current_user || self.owner == current_user
  end
end
