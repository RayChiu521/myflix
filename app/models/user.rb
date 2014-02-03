class User < ActiveRecord::Base

  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :full_name, presence: true

  has_many :queue_items, -> { order("position") }
  has_many :reviews, -> { order("created_at DESC") }
  has_many :followships, class_name: "Followship", foreign_key: "follower_id"
  has_many :followers, class_name: "Followship", foreign_key: "leader_id"

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
end