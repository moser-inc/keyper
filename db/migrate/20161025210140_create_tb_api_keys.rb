class CreateTbApiKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :tb_api_keys do |t|
      t.references :spud_user, foreign_key: true
      t.string :api_key, null: false
      t.string :password_digest
      t.datetime :last_used_at
      t.timestamps
    end
  end
end
