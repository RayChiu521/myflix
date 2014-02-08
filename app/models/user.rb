class User < ActiveRecord::Base

  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :full_name, presence: true

  has_many :queue_items, -> { order("position") }
  has_many :reviews, -> { order("created_at DESC") }
  has_many :followships, class_name: "Followship", foreign_key: "follower_id"
  has_many :followers, class_name: "Followship", foreign_key: "leader_id"
  has_many :password_resets

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: (index + 1))
    end
  end

  def duplicated_position_number?
    queue_items.select("position").group("position").having("count(*) > 1").length > 0
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def followed?(leader)
    leader.in?(followships.map(&:leader))
  end

  def can_follow?(leader)
    !(followed?(leader) || self == leader)
  end

  def generate_password_reset_token
    password_resets.create(token: SecureRandom.urlsafe_base64, expiry_time: token_expired_in_hour, is_used: false)
  end

  def live_password_token
    password_reset = password_resets.where(["is_used = ? AND expiry_time >= ?", false, Time.now]).order("expiry_time DESC").first
    password_reset.token if password_reset
  end

private

  def token_expired_in_hour
    Time.now + 1.hour
  end
end