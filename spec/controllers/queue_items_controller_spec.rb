require 'spec_helper'

describe QueueItemsController do

  describe "GET index" do
    it "sets @queue_items to the queue items of the signed in user" do
      set_current_user
      user = get_current_user
      queue_item1 = Fabricate(:queue_item, creator: user)
      queue_item2 = Fabricate(:queue_item, creator: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it_should_behave_like "require sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    let(:current_user) { get_current_user }
    before do
      set_current_user
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
        expect(QueueItem.first.creator).to eq(current_user)
      end
    end

    context "queue item already has videos" do
      let(:exists_video) { Fabricate(:video) }
      let(:new_video) { Fabricate(:video) }
      before do
        QueueItem.create(video: exists_video, creator: current_user, position: 1)
      end

      it "puts the video as the last one in the queue" do
        post :create, video_id: new_video.id
        queue_item = QueueItem.where(user_id: current_user.id, video_id: new_video.id).first
        expect(queue_item.position).to eq(2)
      end

      it "does not add the video to the queue if the video is already in the queue" do
        post :create, video_id: exists_video.id
        expect(current_user.queue_items.count).to eq(1)
      end
    end

    it_should_behave_like "require sign in" do
      let(:action) { post :create, video_id: Fabricate(:video).id }
    end
  end

  describe "DELETE destroy" do
    let(:current_user) { get_current_user }
    let(:queue_item) { Fabricate(:queue_item, creator: current_user, position: 1) }
    before do
      set_current_user
    end

    it "redirects to the my queue page" do
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "delete the queue item" do
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "normalize the remaining queue items" do
      queue_item2 = Fabricate(:queue_item, creator: current_user, position: 2)
      delete :destroy, id: queue_item.id
      expect(queue_item2.reload.position).to eq(1)
    end

    it "does not delete the queue item if the queue item is not in the current user's queue" do
      queue_item = Fabricate(:queue_item, creator: Fabricate(:user), position: 1)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it_should_behave_like "require sign in" do
      let(:action) { delete :destroy, id: Fabricate(:queue_item).id }
    end
  end

  describe "POST update_queue" do
    let(:current_user) { get_current_user }
    before do
      set_current_user
    end

    let(:video1) { Fabricate(:video) }
    let(:video2) { Fabricate(:video) }
    let(:queue_item_position1) { Fabricate(:queue_item, position: 1, creator: current_user, video: video1) }
    let(:queue_item_position2) { Fabricate(:queue_item, position: 2, creator: current_user, video: video2) }
    let(:queue_items_hash) { {
        queue_item_position1.id => { "position" => 2, "rating" => 1 },
        queue_item_position2.id => { "position" => 1, "rating" => 2 }
      }
    }

    it_should_behave_like "require sign in" do
      let(:action) { post :update_queue, queue_items: {}}
    end

    context "with valid inputs" do
      it "redirects to the my queue page" do
        post :update_queue, queue_items: queue_items_hash
        expect(response).to redirect_to my_queue_path
      end

      it "updates the positions of all received queue items" do
        post :update_queue, queue_items: queue_items_hash
        expect(current_user.queue_items).to eq([queue_item_position2, queue_item_position1])
      end

      it "normalize the position numbers" do
        queue_items_hash[queue_item_position1.id]["position"] = 3
        post :update_queue, queue_items: queue_items_hash
        expect(current_user.queue_items.map(&:position)).to eq([1, 2])
      end

      it "creates a review if haven't" do
        post :update_queue, queue_items: queue_items_hash
        expect(queue_item_position1.video.reviews.count).to eq(1)
      end

      it "updates rating of first review if have" do
        review = Fabricate(:review, creator: current_user, video: queue_item_position1.video, rating: 2)
        post :update_queue, queue_items: queue_items_hash
        expect(review.reload.rating).to eq(1)
      end
    end

    context "with invalid inputs" do
      it "redirects to the my queue page" do
        post :update_queue, queue_items: queue_items_hash
        expect(response).to redirect_to my_queue_path
      end

      it "redirects to my queue page if did not pass queue items" do
        post :update_queue
        expect(response).to redirect_to my_queue_path
      end

      context "if the positions are not integer" do
        before do
          queue_items_hash[queue_item_position2.id]["position"] = 2.2
          post :update_queue, queue_items: queue_items_hash
        end
        it "does not update all received queue items" do
          expect(current_user.queue_items).to eq([queue_item_position1, queue_item_position2])
        end

        it "sets the flash alert message" do
          expect(flash[:alert]).to be_present
        end
      end

      context "if the positions are duplicated" do
        before do
          queue_items_hash[queue_item_position1.id]["position"] = 1
          post :update_queue, queue_items: queue_items_hash
        end

        it "does not update all received queue items" do
          expect(queue_item_position2.reload.position).to eq(2)
        end

        it "sets the flash alert message" do
          expect(flash[:alert]).to be_present
        end
      end

      it "does not create review if rating is blank" do
        queue_items_hash[queue_item_position1.id]["rating"] = ''
        post :update_queue, queue_items: queue_items_hash
        expect(queue_item_position1.video.reviews.count).to eq(0)
      end
    end

    context "with queue items that do not belong to the current user" do
      it "does not change the queue items" do
        another_user = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, creator: another_user, position: 1)
        queue_item2 = Fabricate(:queue_item, creator: current_user, position: 2)

        post :update_queue, queue_items: {
          queue_item1.id => { "position" => 2 },
          queue_item2.id => { "position" => 1 }
        }
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end