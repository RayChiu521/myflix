require 'spec_helper'

describe Category do

  it { should have_many(:videos) }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }

  describe "#recent videos" do
    it "returns the videos in the reverse chronological order by created_at" do
      funny = Category.create(title: "Funny")
      friends = funny.videos.create(title: "Friends", description: "a tv show.", created_at: 1.day.ago)
      pianist = funny.videos.create(title: "Pianist", description: "a movie.")
      expect(funny.recent_videos).to eq([pianist, friends])
    end

    it "returns all videos if there are less than 6 videos" do
      funny = Category.create(title: "Funny")
      friends = funny.videos.create(title: "Friends", description: "a tv show.", created_at: 1.day.ago)
      pianist = funny.videos.create(title: "Pianist", description: "a movie.")
      expect(funny.recent_videos.count).to eq(2)
    end

    it "returns 6 videos if there are more than 6 videos" do
      funny = Category.create(title: "Funny")
      7.times { funny.videos.create(title: "video", description: "a movie.") }
      expect(funny.recent_videos.count).to eq(6)
    end

    it "return the most recent 6 videos" do
      funny = Category.create(title: "Funny")
      6.times { funny.videos.create(title: "video", description: "a movie.") }
      not_recent_video = funny.videos.create(title: "video", description: "a movie.", created_at: 1.day.ago)
      expect(funny.recent_videos).not_to include(not_recent_video)
    end

    it "returns an empty array if the category does not have any videos" do
      funny = Category.create(title: "Funny")
      expect(funny.recent_videos).to eq([])
    end
  end

end