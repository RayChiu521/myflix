require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order("created_at DESC") }


  describe "search_by_title" do
    let(:friends) { Video.create(title: "Friends", description: "a tv show.") }
    let(:pianist) { Video.create(title: "Pianist", description: "a movie.") }

    it "returns an empty array if there is no match" do
      expect(Video.search_by_title("Red")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      expect(Video.search_by_title("Friends")).to eq([friends])
    end

    it "returns an array of one video for a partial match" do
      expect(Video.search_by_title("Fri")).to eq([friends])
    end

    it "returns an array of all matchs ordered by created_at" do
      yesterday_pianist = Video.create(title: "pianist", description: "a tv show.", created_at: 1.day.ago)
      expect(Video.search_by_title("pianist")).to eq([pianist, yesterday_pianist])
    end

    it "returns an empty array for a search with an empty string" do
      expect(Video.search_by_title("")).to eq([])
    end
  end

  describe "#rating" do
    it "returns N/A if has no reviews" do
      video = Fabricate(:video)
      expect(video.rating).to eq("N/A")
    end

    it "returns a review rating if has only one review" do
      review = Fabricate(:review, rating: 5)
      video = Fabricate(:video, reviews: [review])
      expect(video.rating).to eq(5)
    end

    it "returns an average rating of multiple reviews" do
      review1 = Fabricate(:review, rating: 5)
      review2 = Fabricate(:review, rating: 1)
      video = Fabricate(:video, reviews: [review1, review2])
      expect(video.rating).to eq(3)
    end

    it "rounds off to the 2nd decimal place" do
      review1 = Fabricate(:review, rating: 5)
      review2 = Fabricate(:review, rating: 3)
      review3 = Fabricate(:review, rating: 3)
      video = Fabricate(:video, reviews: [review1, review2, review3])
      expect(video.rating).to eq(3.67)
    end
  end
end