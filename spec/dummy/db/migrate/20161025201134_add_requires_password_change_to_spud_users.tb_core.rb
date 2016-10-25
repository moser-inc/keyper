# This migration comes from tb_core (originally 20150610143438)
class AddRequiresPasswordChangeToSpudUsers < ActiveRecord::Migration
  def change
    add_column :spud_users, :requires_password_change, :boolean, :default => false
  end
end
