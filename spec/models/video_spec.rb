require 'spec_helper'

describe Video do

  it "saves itself" do
    video = Video.create!(title: "video", description: "testing video")
    expect(Video.first).to eq(video)
  end

  it "belongs to category" do
    funny = Category.create!(title: "funny")
    friends = Video.create!(title: "friends", description: "a funny television sitcom.", category: funny)
    expect(friends.category).to eq(funny)
  end
end