require "spec_helper"

describe Followship do

  it { should belong_to(:leader) }
  it { should belong_to(:follower) }

end