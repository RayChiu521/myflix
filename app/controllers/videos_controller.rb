class VideosController < AuthenticatedController

  def show
    @video = Video.find(params[:id]).decorate
    @reviews = @video.reviews
  end

  def index
    @category = Category.all
  end

  def search
    redirect_to root_path and return if params[:search_term].blank?
    @videos = Video.search_by_title(params[:search_term])
  end
end