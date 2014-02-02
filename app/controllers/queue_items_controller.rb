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
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    redirect_to my_queue_path
  end

  def change_position
    queue_items_params = params[:queue_items]
    if queue_items_params
      QueueItem.transaction do
        queue_items_params.keys.each do |id|
          raise ActiveRecord::Rollback unless queue_items_params[id][:position].match(/^\d+$/)
          queue_item = QueueItem.find(id)
          if current_user.queue_items.include?(queue_item)
            queue_item.position = queue_items_params[id][:position]
            queue_item.save
          end
        end
        raise ActiveRecord::Rollback if current_user.queue_items.select("position").group("position").having("count(*) > 1").length > 0
      end
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
end