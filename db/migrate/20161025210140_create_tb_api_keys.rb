class CreateTbApiKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :tb_api_keys do |t|
      t.references :spud_user, foreign_key: true
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
