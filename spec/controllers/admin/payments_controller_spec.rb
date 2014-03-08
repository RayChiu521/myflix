require "spec_helper"

describe Admin::PaymentsController do
  before do
    set_current_admin
  end

  describe "GET index" do
    it_should_behave_like "require sign in" do
      let(:action) { get :index }
    end

    it_should_behave_like "requires admin" do
      let(:action) { get :index }
    end

    it "sets the @payments variable" do
      payment1 = Fabricate(:payment)
      payment2 = Fabricate(:payment)
      get :index
      expect(assigns(:payments)).to match_array([payment1, payment2])
    end
  end
end