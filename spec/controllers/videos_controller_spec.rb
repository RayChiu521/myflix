require 'spec_helper'

describe VideosController do

  context 'with a authenticated user' do
    before do
      session[:user_id] = Fabricate(:user).id
    end

    describe "GET show" do
      let(:video) { Fabricate(:video) }
      before { get :show, id: video.id }

      it { assigns(:video).should == video }
      it { should render_template :show }
    end

    describe "POST search" do

      it "returns an array of results" do
        friends = Fabricate(:video, title: 'Friends')
        black_friday = Fabricate(:video, title: 'Black Friday')
        harry_potter = Fabricate(:video, title: 'Harry Potter')

        post :search, search_term: 'Fri'
        assigns(:videos).should == [black_friday, friends]
      end

      it "redirects to root path if search term is blank" do
        post :search, search_term: ''
        should redirect_to root_path
      end
    end
  end
end