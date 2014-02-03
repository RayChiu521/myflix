class QueueItemsController < ApplicationController

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    if queue_item.creator == current_user
      queue_item.destroy
      current_user.normalize_queue_item_positions
    end
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_item_positions
    rescue ActiveRecord::RecordInvalid
      flash[:alert] = "Invalid position numbers."
    rescue Exception => e
      flash[:alert] = e.message
    end

    redirect_to my_queue_path
  end

private

  def queue_video(video)
    QueueItem.create(creator: current_user, video: video, position: new_queue_item_position) unless current_user_queued_video?(video)
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def update_queue_items
    queue_items_params = params[:queue_items]
    if queue_items_params
      ActiveRecord::Base.transaction do
        queue_items_params.each do |key, value|
          queue_item = QueueItem.find(key)
          queue_item.update_attributes!(position: value[:position], rating: value[:rating]) if queue_item.creator == current_user
        end
        raise "Duplicated position numbers." if current_user.duplicated_position_number?
      end
    end
  end
end