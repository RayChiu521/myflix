class Invitation < ActiveRecord::Base

  belongs_to :invitor, class_name: "User", foreign_key: "user_id"

  validates_presence_of :recipient_name, :recipient_email, :message

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end