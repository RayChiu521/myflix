require "spec_helper"

describe VideoDecorator do
  describe "#rating" do
    it "returns N/A if has no reviews" do
      video = Fabricate(:video)
      expect(video.decorate.rating).to eq("N/A")
    end

    it "returns a review rating if has only one review" do
      review = Fabricate(:review, rating: 5)
      video = Fabricate(:video, reviews: [review])
      expect(video.decorate.rating).to eq(5)
    end

    it "returns an average rating of multiple reviews" do
      review1 = Fabricate(:review, rating: 5)
      review2 = Fabricate(:review, rating: 1)
      video = Fabricate(:video, reviews: [review1, review2])
      expect(video.decorate.rating).to eq(3)
    end

    it "rounds off to the 2nd decimal place" do
      review1 = Fabricate(:review, rating: 5)
      review2 = Fabricate(:review, rating: 3)
      review3 = Fabricate(:review, rating: 3)
      video = Fabricate(:video, reviews: [review1, review2, review3])
      expect(video.decorate.rating).to eq(3.67)
    end
  end
end