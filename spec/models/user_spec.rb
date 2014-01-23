require 'spec_helper'

describe User do

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password).on(:create) }
  it { should validate_presence_of(:full_name) }

  it do
    User.create(email: 'test@test.com', password: 'test', password_confirmation: 'test', full_name: 'test')
    should validate_uniqueness_of(:email)
  end

end