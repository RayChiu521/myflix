class VideoDecorator

  extend Forwardable

  def_delegator :@video, :reviews
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def rating
    return "N/A" if reviews.blank?
    (reviews.collect(&:rating).sum.to_f / reviews.length).round(2)
  end

end