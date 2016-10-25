# This migration comes from tb_core (originally 20130620143941)
class CreateSpudPermissions < ActiveRecord::Migration
  def change
    create_table :spud_permissions do |t|
      t.string :name, :null => false
      t.string :tag, :null => false
      t.timestamps
    end
    add_index :spud_permissions, :tag, :unique => true
  end
end
