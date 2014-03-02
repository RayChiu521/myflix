require "spec_helper"

describe VideoDecorator do
  describe "#rating" do
    it "returns N/A if has no reviews" do
      video = Fabricate(:video)
      expect(video.decorate.rating).to eq("N/A")
    end

    it "returns an average rating of multiple reviews and followed by /5.0" do
      review1 = Fabricate(:review, rating: 5)
      review2 = Fabricate(:review, rating: 1)
      video = Fabricate(:video, reviews: [review1, review2])
      expect(video.decorate.rating).to eq("3.0/5.0")
    end

  end
end