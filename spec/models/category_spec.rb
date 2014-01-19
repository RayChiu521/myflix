require 'spec_helper'

describe Category do

  it "saves itself" do
    funny = Category.create!(title: "funny")
    expect(Category.first).to eq(funny)
  end

  it "has many videos" do
    funny = Category.create!(title: "funny")
    friends = Video.create!(title: "friends", description: "a funny television sitcom.", category: funny)
    south_park = Video.create!(title: "south park", description: "a funny cartoon.", category: funny)
    expect(funny.videos).to eq([friends, south_park])
  end
end