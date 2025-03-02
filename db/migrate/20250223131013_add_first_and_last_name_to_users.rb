class AddFirstAndLastNameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string, default: "Unknown"
    add_column :users, :last_name, :string, default: "User"
  end
end
