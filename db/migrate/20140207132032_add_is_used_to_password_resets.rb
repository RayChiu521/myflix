class AddIsUsedToPasswordResets < ActiveRecord::Migration
  def change
    add_column :password_resets, :is_used, :boolean
  end
end
