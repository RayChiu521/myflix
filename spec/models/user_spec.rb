require 'spec_helper'

describe User do

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password).on(:create) }
  it { should validate_presence_of(:full_name) }
  it { should have_many(:queue_items).order("position") }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_many(:followships) }
  it { should have_many(:followers) }
  it { should have_many(:password_resets) }

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

  describe "#generate_password_reset_token" do
    let(:user) { Fabricate(:user) }

    it "creates a password reset record with token" do
      user.generate_password_reset_token
      expect(PasswordReset.first.token).not_to be_blank
    end

    it "creates a password reset record with expiry time that expired in an hour" do
      user.generate_password_reset_token
      expect(PasswordReset.first.expiry_time).to be >= Time.now + 50.minute
      expect(PasswordReset.first.expiry_time).to be <= Time.now + 70.minute
    end
  end

  describe "#live_password_token" do
    let(:user) { Fabricate(:user) }

    context "with user has password_resets and at least one expiry_time column of password_resets is greater than or equal to Time.now" do

      it "returns a token if only one password_reset is satisfy" do
        password_reset = Fabricate(:password_reset, user: user, expiry_time: Time.now + 1.hour)
        expect(user.live_password_token).to eq(password_reset.token)
      end

      it "returns a token with newest expiry_time if multiple password_resets are satisfy" do
        password_reset1 = Fabricate(:password_reset, user: user, expiry_time: Time.now + 50.minute)
        password_reset2 = Fabricate(:password_reset, user: user, expiry_time: Time.now + 55.minute)
        expect(user.live_password_token).to eq(password_reset2.token)
      end
    end

    it "returns nil if user's password_resets is empty" do
      expect(user.live_password_token).to be_nil
    end

    it "returns nil if all expiry_time columns are less than Time.now" do
      password_reset1 = Fabricate(:password_reset, user: user, expiry_time: Time.now - 1.minute)
      expect(user.live_password_token).to be_nil
    end
  end

end