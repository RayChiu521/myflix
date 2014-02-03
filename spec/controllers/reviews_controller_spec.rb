require 'spec_helper'

describe ReviewsController do

  describe "POST create" do
    let(:video) { Fabricate(:video) }
    let(:current_user) { get_current_user }
    before do
      set_current_user
    end

    context "with valid input" do
      before do
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
      end

      it "redirects to the video show page" do
        expect(response).to redirect_to video
      end

      it "creates a review" do
        expect(Review.count).to eq(1)
      end

      it "creates a review associated with the video" do
        expect(Review.first.video).to eq(video)
      end

      it "creates a review associated with the signed in user" do
        expect(Review.first.creator).to eq(current_user)
      end
    end

    context "with invalid input" do
      before do
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review, content: "")
      end

      it "renders the videos/show template" do
        expect(response).to render_template "videos/show"
      end

      it "does not create a review" do
        expect(Review.count).to eq(0)
      end

      it "sets @video" do
        expect(assigns(:video)).to eq(video)
      end

      it "sets @reviews" do
        expect(assigns(:reviews)).to eq(video.reviews)
      end
    end

    it_should_behave_like "require sign in" do
      let(:action) { post :create, video_id: video.id, review: Fabricate.attributes_for(:review) }
    end
  end
end