require "spec_helper"

describe Admin::VideosController do
  before do
    set_current_admin
  end

  describe "GET new" do
    it_should_behave_like "require sign in" do
      let(:action) { get :new }
    end

    it_should_behave_like "requires admin" do
      let(:action) { get :new }
    end

    it "sets the @video to a new Video" do
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end
  end

  describe "POST create" do
    it_should_behave_like "require sign in" do
      let(:action) { post :create }
    end

    it_should_behave_like "requires admin" do
      let(:action) { post :create }
    end

    context "with valid inputs" do
      let(:video_attributes) { Fabricate.attributes_for(:video) }

      it "redirects to the new admin video page" do
        post :create, video: video_attributes
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates the video" do
        post :create, video: video_attributes
        expect(Video.count).to eq(1)
      end


      it "sets the successfully flash message" do
        post :create, video: video_attributes
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid inputs" do
      let(:video_attributes) { Fabricate.attributes_for(:video, title: nil) }

      it "does not create a video" do
        post :create, video: video_attributes
        expect(Video.count).to eq(0)
      end

      it "renders the new template" do
        post :create, video: video_attributes
        expect(response).to render_template :new
      end

      it "sets the @video" do
        post :create, video: video_attributes
        expect(assigns(:video)).to be_present
      end

      it "sets the error flash message" do
        post :create, video: video_attributes
        expect(flash[:alert]).to be_present
      end
    end

  end
end