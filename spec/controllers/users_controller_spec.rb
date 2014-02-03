require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "sets the @user to a new User" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do
    let(:user_hash) { Fabricate.attributes_for(:user) }

    context "with valid input" do
      before do
        post :create, user: user_hash
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with invalid input" do
      before do
        user_hash[:email] = nil
        post :create, user: user_hash
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "sets the @user" do
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end
end