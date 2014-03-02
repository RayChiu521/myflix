class VideoDecorator < Draper::Decorator

  delegate_all

  def rating
    return "N/A" if reviews.blank?
    (reviews.collect(&:rating).sum.to_f / reviews.length).round(2)
  end

end