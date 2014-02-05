class Review < ActiveRecord::Base

  belongs_to :video
  belongs_to :creator, class_name: "User", foreign_key: "user_id"

  validates_presence_of :content, :rating

  def video_title
    video.title
  end
end