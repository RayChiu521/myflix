require "spec_helper"

describe SessionsController do

  describe "GET new" do
    context "with authenticated users" do
      it "redirects to home page" do
        set_current_user
        get :new
        expect(response).to redirect_to home_path
      end
    end

    context "with unauthenticated users" do
      before do
        get :new
      end

      it "sets the @user" do
        expect(assigns(:user)).to be_a_new(User)
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "POST create" do
    let(:user) { Fabricate(:user, password: 'password') }
    let(:user_hash) { { email: user.email, password: 'password' } }

    context "with valid input" do
      before do
        post :create, user: user_hash
      end

      it "sets the session[:user_id]" do
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end

      it "sets the notice message" do
        expect(flash[:notice]).not_to be_blank
      end
    end

    context "with invalid input" do
      before do
        user_hash[:password] = nil
        post :create, user: user_hash
      end

      it "does not set the session[:user_id]" do
        expect(session[:user_id]).to be_nil
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "sets the alert message" do
        expect(flash[:alert]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    before do
      set_current_user
    end

    it "clears the session[:user_id]" do
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the root path" do
      get :destroy
      expect(response).to redirect_to root_path
    end

    it "sets the notice message" do
      get :destroy
      expect(flash[:notice]).not_to be_blank
    end

    it_should_behave_like "require sign in" do
      let(:action) { get :destroy }
    end
  end
end