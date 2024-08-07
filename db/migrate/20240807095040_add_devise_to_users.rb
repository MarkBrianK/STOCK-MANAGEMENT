class AddDeviseToUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users, bulk: true do |t|
      ## Database authenticatable
      # Comment out the email field if it already exists
      # t.string :email, null: false, default: ""

      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      # Add additional Devise modules as needed
      # t.string :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string :unconfirmed_email # Only if using reconfirmable
    end

    # If an index on email already exists, comment this out as well
    # add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token, unique: true
  end
end
