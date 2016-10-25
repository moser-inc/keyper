# This migration comes from tb_core (originally 20120327124229)
class AddTimeZoneToSpudUser < ActiveRecord::Migration
  def change
    add_column :spud_users, :time_zone, :string

  end
end
