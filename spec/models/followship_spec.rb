require "spec_helper"

describe Followship do

  it { should belong_to(:user) }
  it { should belong_to(:follower) }

end