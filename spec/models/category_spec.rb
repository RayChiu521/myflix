require 'spec_helper'

describe Category do

  it "saves itself" do
    funny = Category.create!(title: "funny")
    expect(Category.first).to eq(funny)
  end
end