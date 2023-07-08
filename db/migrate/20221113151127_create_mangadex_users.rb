class CreateMangadexUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :mangadex_users do |t|
      t.string :session
      t.string :refresh
      t.string :username, null: false
      t.string :mangadex_user_id, null: false
      t.datetime :session_valid_until
      t.references :user, null: false

      t.timestamps
    end
  end
end
