require 'spec_helper'

describe User do

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password).on(:create) }
  it { should validate_presence_of(:full_name) }
  it { should have_many(:queue_items).order("position") }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_many(:followships) }
  it { should have_many(:followers) }

  it do
    User.create(email: 'test@test.com', password: 'test', password_confirmation: 'test', full_name: 'test')
    should validate_uniqueness_of(:email)
  end

  describe "#followed?" do
    let(:leader) { Fabricate(:user) }
    let(:follower) { Fabricate(:user) }

    before do
      Followship.create(leader: leader, follower: follower)
    end

    it "returns true if is follower" do
      expect(follower.followed?(leader)).to be_true
    end

    it "returns false if is not follower" do
      not_leader = Fabricate(:user)
      expect(follower.followed?(not_leader)).to be_false
    end
  end

end