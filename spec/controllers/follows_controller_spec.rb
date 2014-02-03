require "spec_helper"

describe FollowsController do

  describe "GET index" do
    let(:current_user) { get_current_user }
    let(:user1) { Fabricate(:user) }
    let(:user2) { Fabricate(:user) }
    let(:follow1) { Fabricate(:follow, user: user1, follower: current_user) }
    let(:follow2) { Fabricate(:follow, user: user2, follower: current_user) }

    before do
      set_current_user
    end

    it_should_behave_like "require sign in" do
      let(:action) { get :index }
    end

    it "sets @follows" do
      get :index
      expect(assigns(:follows)).to match_array([follow1, follow2])
    end
  end

end