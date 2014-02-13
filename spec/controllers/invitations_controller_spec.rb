require "spec_helper"

describe InvitationsController do
  describe "GET new" do
    before do
      set_current_user
    end

    it_should_behave_like "require sign in" do
      let(:action) { get :new }
    end

    it "sets the @invitation variable to a new invitation" do
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end
  end

  describe "POST create" do
    before do
      set_current_user
    end

    after { ActionMailer::Base.deliveries.clear }

    it_should_behave_like "require sign in" do
      let(:action) { post :create }
    end

    context "with valid inputs" do
      let(:phoebe_data) { { recipient_name: "phoebe", recipient_email: "phoebe@example.com", message: "Please join this really cool site!" } }

      it "redirects to the invitation page" do
        post :create, invitation: phoebe_data
        expect(response).to redirect_to invitation_path
      end

      it "creates an invitation" do
        post :create, invitation: phoebe_data
        expect(Invitation.count).to eq(1)
      end

      it "sends an email to the friend's email address" do
        post :create, invitation: phoebe_data
        expect(ActionMailer::Base.deliveries.last.to).to eq(["phoebe@example.com"])
      end

      it "sets the successfully flash message" do
        post :create, invitation: phoebe_data
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid inputs" do
      let(:phoebe_data) { { name: "", email: "phoebe@example.com", message: "Please join this really cool site!" } }

      it "renders the :new template"do
        post :create, invitation: phoebe_data
        expect(response).to render_template :new
      end

      it "does not create an invitation" do
        post :create, invitation: phoebe_data
        expect(Invitation.count).to eq(0)
      end

      it "does not send out an email" do
        post :create, invitation: phoebe_data
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets the @invitation" do
        post :create, invitation: phoebe_data
        expect(assigns(:invitation)).to be_present
      end
    end
  end
end