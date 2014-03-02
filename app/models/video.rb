class Video < ActiveRecord::Base

	belongs_to :category
  has_many :reviews, -> { order("created_at DESC") }

  validates_presence_of :title, :description

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(search_term = nil)
    return [] if search_term.blank?
    where(["title LIKE ?", "%#{search_term}%"]).order("created_at DESC")
  end

  def rating
    return "N/A" if reviews.blank?
    (reviews.collect(&:rating).sum.to_f / reviews.length).round(2)
  end

end