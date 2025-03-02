class RemoveDefaultFromUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :first_name, nil
    change_column_default :users, :last_name, nil
  end
end
