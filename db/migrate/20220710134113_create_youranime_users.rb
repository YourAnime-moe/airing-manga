class CreateYouranimeUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :youranime_users do |t|
      t.string :access_token
      t.string :refresh_token
      t.string :username, null: false
      t.string :uuid, null: false

      t.datetime :access_token_expires_on
      t.references :user, null: false

      t.timestamps
    end
  end
end
