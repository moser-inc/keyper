# This migration comes from keyper (originally 20161025210140)
class CreateKeyperApiKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :keyper_api_keys do |t|
      t.references :user, foreign_key: false
      t.string :api_key, null: false
      t.index :api_key, unique: true
      t.string :password_digest, null: false
      t.datetime :last_used_at
      t.string :last_used_ip
      t.string :last_used_ua
      t.timestamps
    end
  end
end
