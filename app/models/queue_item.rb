class QueueItem < ActiveRecord::Base

  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :video

  validates_numericality_of :position, only_integer: true

  def video_title
    video.title
  end

  def rating
    review = Review.where(user_id: creator.id, video_id: video.id).order("created_at DESC").first
    review.rating if review
  end

  def category_title
    video.category.title
  end

  def category
    video.category
  end
end