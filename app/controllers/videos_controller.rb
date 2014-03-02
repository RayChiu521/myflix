class VideosController < AuthenticatedController

  before_action :set_video, only: [:show]

  def show
   @reviews = @video.reviews
  end

  def index
    @category = Category.all
  end

  def search
    redirect_to root_path and return if params[:search_term].blank?
    @videos = Video.search_by_title(params[:search_term])
  end


private

  def set_video
    @video = Video.find(params[:id]).decorate
  end
end