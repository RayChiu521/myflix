class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      redirect_to new_admin_video_path, notice: "Video #{@video.title} has been created!"
    else
      flash.now[:alert] = "You can't add this video, please fix errors!"
      render :new
    end
  end

private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover)
  end
end