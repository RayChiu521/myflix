require 'spec_helper'

describe Review do

  it { should belong_to(:video) }
  it { should belong_to(:creator) }
  it { should validate_presence_of(:rating) }
  it { should validate_presence_of(:content) }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video, title: "Friends")
      review = Fabricate(:review, video: video)
      expect(review.video_title).to eq("Friends")
    end
  end
end