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
          QueueItem.create(video: exists_video, creator: user, position: 1)
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

  describe "DELETE destroy" do
    context "with authenticated users" do
      let(:user) { Fabricate(:user) }
      let(:queue_item) { Fabricate(:queue_item, creator: user) }
      before do
        session[:user_id] = user.id
      end

      it "redirects to the my queue page" do
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "delete the queue item" do
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "does not delete the queue item if the queue item is not in the current user's queue" do
        another_user = Fabricate(:user)
        session[:user_id] = another_user.id
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end
    end

    it "redirects to the sign in page for unauthenticated users" do
      delete :destroy, id: Fabricate(:queue_item).id
      expect(QueueItem.count).to eq(1)
    end
  end

  describe "POST update_queue" do
    context "with authenticated users" do
      let(:user) { Fabricate(:user) }
      let(:queue_item_position1) { Fabricate(:queue_item, position: 1, creator: user) }
      let(:queue_item_position2) { Fabricate(:queue_item, position: 2, creator: user) }
      let(:queue_items_hash) { {
          queue_item_position1.id => { "position" => 2 },
          queue_item_position2.id => { "position" => 1 }
        }
      }
      before do
        session[:user_id] = user.id
      end

      context "with valid inputs" do
        it "redirects to the my queue page" do
          post :update_queue, queue_items: queue_items_hash
          expect(response).to redirect_to my_queue_path
        end

        it "updates the positions of all received queue items" do
          post :update_queue, queue_items: queue_items_hash
          expect(user.queue_items).to eq([queue_item_position2, queue_item_position1])
        end

        it "normalize the position numbers" do
          queue_items_hash[queue_item_position1.id]["position"] = 3
          post :update_queue, queue_items: queue_items_hash
          expect(user.queue_items.map(&:position)).to eq([1, 2])
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
            expect(user.queue_items).to eq([queue_item_position1, queue_item_position2])
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
      end
    end

    it "redirects to signed in page for unauthenticated users" do
      post :update_queue, queue_items: {}
      expect(response).to redirect_to sign_in_path
    end

    context "with queue items that do not belong to the current user" do
      it "does not change the queue items" do
        current_user = Fabricate(:user)
        another_user = Fabricate(:user)
        session[:user_id] = current_user.id
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