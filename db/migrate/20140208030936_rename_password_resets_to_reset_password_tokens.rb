class RenamePasswordResetsToResetPasswordTokens < ActiveRecord::Migration
  def change
    rename_table :password_resets, :reset_password_tokens
  end
end
