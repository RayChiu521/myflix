require 'spec_helper'

describe Video do

  it "saves itself" do
    video = Video.create!(title: "video", description: "testing video")
    expect(Video.first).to eq(video)
  end

end