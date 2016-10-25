# This migration comes from tb_core (originally 20130620151132)
class CreateSpudRolePermissions < ActiveRecord::Migration
  def change
    create_table :spud_role_permissions do |t|
      t.integer :spud_role_id, :null => false
      t.string :spud_permission_tag, :null => false
      t.timestamps
    end
    add_index :spud_role_permissions, :spud_role_id
    add_index :spud_role_permissions, :spud_permission_tag
  end
end
