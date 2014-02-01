require 'spec_helper'

describe QueueItemsController do

  describe "GET index" do
    it "sets @queue_items to the queue items of the signed in user" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, creator: user)
      queue_item2 = Fabricate(:queue_item, creator: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do
    context "with authenticated users" do
      let(:user) { Fabricate(:user) }
      before do
        session[:user_id] = user.id
      end

      context "does not worry about video number of queue item" do
        let(:video) { Fabricate(:video) }
        before do
          post :create, video_id: video.id
        end

        it "redirects to the my queue page" do
          expect(response).to redirect_to my_queue_path
        end

        it "creates a queue item" do
          expect(QueueItem.count).to eq(1)
        end

        it "creates a queue item that is associated with the video" do
          expect(QueueItem.first.video).to eq(video)
        end

        it "creates a queue item that is associated with the signed in user" do
          expect(QueueItem.first.creator).to eq(user)
        end
      end

      context "queue item already has videos" do
        let(:exists_video) { Fabricate(:video) }
        let(:new_video) { Fabricate(:video) }
        before do
          QueueItem.create(video: exists_video, creator: user)
        end

        it "puts the video as the last one in the queue" do
          post :create, video_id: new_video.id
          queue_item = QueueItem.where(user_id: user.id, video_id: new_video.id).first
          expect(queue_item.position).to eq(2)
        end

        it "does not add the video to the queue if the video is already in the queue" do
          post :create, video_id: exists_video.id
          expect(user.queue_items.count).to eq(1)
        end
      end
    end

    it "redirects to the sign in page for unauthenticated users" do
      post :create, video_id: Fabricate(:video).id
      expect(response).to redirect_to sign_in_path
    end
  end

end