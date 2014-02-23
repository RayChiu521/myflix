class ReviewsController < AuthenticatedController

  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.build(review_params)
    if review.save
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      render "videos/show"
    end
  end

private

  def review_params
    params.require(:review).permit(:rating, :content).merge(creator: current_user)
  end
end