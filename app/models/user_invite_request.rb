class UserInviteRequest < ActiveRecord::Base
  belongs_to :user
  
  before_update :check_status, :grant_request
  
  named_scope :not_handled, :conditions => {:handled => false}
  
  private
  
  #Mark the request granted and/or handled as appropriate
  def check_status
    self.handled = true
    if self.quantity > 0
      self.granted = true
    end  
  end
  
  #Create new invitations for the user who requested them
  def grant_request
    if self.granted?
      self.quantity.times do 
        self.user.invitations.create
      end
      UserMailer.deliver_invite_increase_notification(self.user, self.quantity)
    end
  end
end