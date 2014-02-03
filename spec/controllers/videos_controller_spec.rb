require 'spec_helper'

describe VideosController do

  describe "GET show" do
    before do
      set_current_user
    end

    it "sets the @video for authenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "sets the @reviews for authenticated users" do
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array [review1, review2]
    end

    it_should_behave_like "require sign in" do
      let(:action) { get :show, id: 1 }
    end
  end

  describe "POST search" do
    before do
      set_current_user
    end

    it "sets the @videos" do
      video = Fabricate(:video, title: "Friends")
      post :search, search_term: "Fri"
      expect(assigns(:videos)).to eq([video])
    end

    it "redirects to root path if search term is blank" do
      post :search
      expect(response).to redirect_to root_path
    end

    it_should_behave_like "require sign in" do
      let(:action) { post :search, search_term: "Fri" }
    end
  end
end