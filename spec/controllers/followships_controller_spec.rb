require "spec_helper"

describe FollowshipsController do

  describe "GET index" do
    let(:current_user) { get_current_user }
    let(:user1) { Fabricate(:user) }
    let(:user2) { Fabricate(:user) }
    let(:followship1) { Fabricate(:followship, leader: user1, follower: current_user) }
    let(:followship2) { Fabricate(:followship, leader: user2, follower: current_user) }

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
    let(:leader) { Fabricate(:user) }
    let(:followship) { Fabricate(:followship, leader: leader, follower: current_user) }

    before do
      set_current_user
    end

    it_should_behave_like "require sign in" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "redirects to the people page" do
      delete :destroy, id: followship.id
      expect(response).to redirect_to people_path
    end

    it "deletes the followship if the current user is the follower" do
      delete :destroy, id: followship.id
      expect(current_user.followships.reload.count).to eq(0)
    end

    it "does not delete the followship if the current user is not the follower" do
      another_user = Fabricate(:user)
      new_followship = Fabricate(:followship, leader: leader, follower: another_user)
      delete :destroy, id: new_followship.id
      expect(another_user.followships.reload.count).to eq(1)
    end
  end

end