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
end