class AddIndexLeaderIdAndFollowerId < ActiveRecord::Migration
  def change
    add_index :followships, :leader_id
    add_index :followships, :follower_id
  end
end
