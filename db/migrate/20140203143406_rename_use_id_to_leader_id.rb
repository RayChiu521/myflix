class RenameUseIdToLeaderId < ActiveRecord::Migration
  def change
    rename_column :followships, :user_id, :leader_id
  end
end
