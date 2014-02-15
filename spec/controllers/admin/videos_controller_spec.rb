require "spec_helper"

describe Admin::VideosController do
  describe "GET new" do
    before do
      set_current_admin
    end

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
end