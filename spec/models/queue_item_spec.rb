require "spec_helper"

describe QueueItem do

  it { should belong_to :creator }
  it { should belong_to :video }
  it { should validate_numericality_of(:position).only_integer() }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video, title: "Friends")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("Friends")
    end
  end

  describe "#rating" do
    it "returns the rating from the review when the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, creator: user, rating: 4)
      queue_item = Fabricate(:queue_item, creator: user, video: video)
      expect(queue_item.rating).to eq(4)
    end

    it "return nil when the review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, creator: user, video: video)
      expect(queue_item.rating).to be_nil
    end
  end

  describe "#rating=" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:queue_item) { Fabricate(:queue_item, creator: user, video: video) }

    context "if the review is present" do
      before do
        Fabricate(:review, creator: user, video: video, rating: 2)
      end

      it "changes the rating of the video" do
        queue_item.rating = 4
        expect(Review.first.rating).to eq(4)
      end

      it "clears the rating of the review" do
        queue_item.rating = nil
        expect(Review.first.rating).to be_nil
      end
    end

    context "if the review is not present" do
      it "creates a review with the rating" do
        queue_item.rating = 4
        expect(Review.first.rating).to eq(4)
      end

      it "does not create a review without the rating" do
        queue_item.rating = nil
        expect(Review.count).to eq(0)
      end
    end
  end

  describe "#category_title" do
    it "returns the category title of the video" do
      category = Fabricate(:category, title: "Comdey")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_title).to eq("Comdey")
    end
  end

  describe "#cateory" do
    it "returns the category of the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
end