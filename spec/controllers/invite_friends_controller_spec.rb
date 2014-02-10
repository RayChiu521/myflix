require "spec_helper"

describe InviteFriendsController do
  describe "POST create" do
    before do
      set_current_user
    end

    context "with valid inputs" do
      let(:phoebe_data) { { name: "phoebe", email: "phoebe@example.com", message: "Please join this really cool site!" } }

      after do
        ActionMailer::Base.deliveries.clear
      end

      it "redirects to the invite user page" do
        post :create, phoebe_data
        expect(response).to redirect_to invite_friend_path
      end

      it "sends an email to the friend's email address" do
        post :create, phoebe_data
        expect(ActionMailer::Base.deliveries.last.to).to eq(["phoebe@example.com"])
      end

      it "sets the successfully flash message" do
        post :create, phoebe_data
        expect(flash[:notice]).to be_present
      end
    end

    context "if the friend's email is blank" do

      it "redirects to the invite user page" do
        post :create, { name: "phoebe", email: "", message: "Please join this really cool site!" }
        expect(response).to redirect_to invite_friend_path
      end

      it "sets the warning flash message" do
        post :create, { name: "phoebe", email: "", message: "Please join this really cool site!" }
        expect(flash[:alert]).to eq("Please input your Friend's email!")
      end
    end

    context "if the friend already is a member" do
      let(:phoebe) { Fabricate(:user) }
      let(:phoebe_data) { { name: "phoebe", email: phoebe.email, message: "Please join this really cool site!" } }

      it "redirects to the invite user page" do
        post :create, phoebe_data
        expect(response).to redirect_to invite_friend_path
      end

      it "sets the warning flash message" do
        post :create, phoebe_data
        expect(flash[:alert]).to eq("Your friend already is our member!")
      end
    end

    it_should_behave_like "require sign in" do
      let(:action) { post :create }
    end
  end
end