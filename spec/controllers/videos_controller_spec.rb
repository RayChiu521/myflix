require 'spec_helper'

describe VideosController do

  describe "GET show" do
    it "sets the @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "sets the @reviews for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array [review1, review2]
    end

    it "redirects to the sign in path for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST search" do
    context "with authenticated users" do
      before do
        session[:user_id] = Fabricate(:user).id
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
    end


    it "redirects to sign in path for unauthenticated users" do
      video = Fabricate(:video, title: "Friends")
      post :search, search_term: "Fri"
      expect(response).to redirect_to sign_in_path
    end
  end
end