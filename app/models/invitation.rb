require_relative '../../lib/tokenable'

class Invitation < ActiveRecord::Base

  include Tokenable

  belongs_to :invitor, class_name: "User", foreign_key: "user_id"

  validates_presence_of :recipient_name, :recipient_email, :message

end