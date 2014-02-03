require "spec_helper"

describe FollowshipsController do

  describe "GET index" do
    let(:current_user) { get_current_user }
    let(:user1) { Fabricate(:user) }
    let(:user2) { Fabricate(:user) }
    let(:followship1) { Fabricate(:followship, user: user1, follower: current_user) }
    let(:followship2) { Fabricate(:followship, user: user2, follower: current_user) }

    before do
      set_current_user
    end

    it_should_behave_like "require sign in" do
      let(:action) { get :index }
    end

    it "sets @followships" do
      get :index
      expect(assigns(:followships)).to match_array([followship1, followship2])
    end
  end

  describe "DELETE destroy" do
    let(:current_user) { get_current_user }
    let(:followed1) { Fabricate(:user) }
    let(:followed2) { Fabricate(:user) }

    before do
      set_current_user
      Fabricate(:followship, user: followed1, follower: current_user)
      Fabricate(:followship, user: followed2, follower: current_user)
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
      expect(current_user.followships.reload.count).to eq(1)
    end

    it "does not delete a user if current user did not followship this user" do
      another_user = Fabricate(:user)
      new_follow = Fabricate(:followship, user: followed1, follower: another_user)
      delete :destroy, id: new_follow.id
      expect(another_user.followships.reload.count).to eq(1)
    end
  end

end