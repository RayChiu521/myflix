class QueueItem < ActiveRecord::Base

  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :video

  validates_numericality_of :position, only_integer: true

  def video_title
    video.title
  end

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating)
    elsif !new_rating.blank?
      review = Review.new(creator: creator, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  def category_title
    video.category.title
  end

  def category
    video.category
  end

private

  def review
    @review ||= Review.where(user_id: creator.id, video_id: video.id).order("created_at DESC").first
  end
end