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

  describe "DELETE destroy" do
    let(:current_user) { get_current_user }
    let(:followed1) { Fabricate(:user) }
    let(:followed2) { Fabricate(:user) }

    before do
      set_current_user
      Fabricate(:follow, user: followed1, follower: current_user)
      Fabricate(:follow, user: followed2, follower: current_user)
    end

    it_should_behave_like "require sign in" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "redirects to the people page" do
      delete :destroy, id: followed1.id
      expect(response).to redirect_to people_path
    end

    it "deletes a user that current user followed" do
      delete :destroy, id: followed1.id
      expect(current_user.follows.reload.count).to eq(1)
    end

    it "does not delete a user if current user did not follow this user" do
      another_user = Fabricate(:user)
      new_follow = Fabricate(:follow, user: followed1, follower: another_user)
      delete :destroy, id: new_follow.id
      expect(another_user.follows.reload.count).to eq(1)
    end
  end

end