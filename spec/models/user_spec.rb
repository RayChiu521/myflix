require 'spec_helper'

describe User do

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password).on(:create) }
  it { should validate_presence_of(:full_name) }
  it { should have_many(:queue_items).order("position") }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_many(:followships) }
  it { should have_many(:followers) }
  it { should have_many(:reset_password_tokens) }

  it do
    User.create(email: 'test@test.com', password: 'test', password_confirmation: 'test', full_name: 'test')
    should validate_uniqueness_of(:email)
  end

  describe "#generate_password_reset_token" do
    let(:user) { Fabricate(:user) }

    it "creates a password reset record with token" do
      user.generate_password_reset_token
      expect(ResetPasswordToken.first.token).to be_present
    end

    it "creates a password reset record with expiry time that expired in an hour" do
      user.generate_password_reset_token
      expect(ResetPasswordToken.first.expiry_time).to be >= Time.now + 50.minute
      expect(ResetPasswordToken.first.expiry_time).to be <= Time.now + 70.minute
    end
  end

  describe "#live_password_token" do
    let(:user) { Fabricate(:user) }

    context "with user has password_resets and at least one expiry_time column of password_resets is greater than or equal to Time.now and is_used is false" do

      it "returns a token if only one reset_password_token is satisfy" do
        reset_password_token = Fabricate(:reset_password_token, user: user, expiry_time: Time.now + 1.hour, is_used: false)
        expect(user.live_password_token).to eq(reset_password_token.token)
      end

      it "returns a token with newest expiry_time if multiple password_resets are satisfy" do
        password_reset1 = Fabricate(:reset_password_token, user: user, expiry_time: Time.now + 50.minute, is_used: false)
        password_reset2 = Fabricate(:reset_password_token, user: user, expiry_time: Time.now + 55.minute, is_used: false)
        expect(user.live_password_token).to eq(password_reset2.token)
      end
    end

    it "returns nil if user's password_resets is empty" do
      expect(user.live_password_token).to be_nil
    end

    it "returns nil if all expiry_time columns are less than Time.now" do
      Fabricate(:reset_password_token, user: user, expiry_time: Time.now - 1.minute, is_used: false)
      expect(user.live_password_token).to be_nil
    end

    it "returns nil if all resets are already been used" do
      Fabricate(:reset_password_token, user: user, expiry_time: Time.now, is_used: true)
      expect(user.live_password_token).to be_nil
    end
  end

  describe ".registered?" do
    it "returns false if the email is blank" do
      expect(User.registered?("")).to be_false
    end

    it "returns false if the email has been registered" do
      expect(User.registered?("monica@example.com")).to be_false
    end

    it "returns false if the email has not been registered" do
      monica = Fabricate(:user)
      expect(User.registered?(monica.email)).to be_true
    end
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

  describe "follow!" do
    let(:monica) { Fabricate(:user) }
    let(:phoebe) { Fabricate(:user) }

    it "follows leader if not follows one self" do
      expect(monica.follow!(phoebe)).to be_true
    end

    it "does not follow leader if follows self" do
      expect(monica.follow!(monica)).to be_false
    end
  end

  describe "bifollow!" do
    let(:monica) { Fabricate(:user) }
    let(:phoebe) { Fabricate(:user) }

    it "follows each other if not follows one self" do
      expect(monica.bifollow!(phoebe)).to be_true
      expect(phoebe.bifollow!(monica)).to be_true
    end

    it "does not follow each other if follows self" do
      expect(monica.bifollow!(monica)).to be_false
    end
  end
end