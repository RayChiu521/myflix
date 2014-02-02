require "spec_helper"

describe QueueItem do

  it { should belong_to :creator }
  it { should belong_to :video }

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

  it "orders by position ASC" do
    queue_item_position1 = Fabricate(:queue_item, position: 1)
    queue_item_position2 = Fabricate(:queue_item, position: 2)
    expect(QueueItem.all).to eq([queue_item_position1, queue_item_position2])
  end
end