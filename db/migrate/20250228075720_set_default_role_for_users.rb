class SetDefaultRoleForUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :role, "unassigned"
    User.where(role: nil).update_all(role: "unassigned")
  end
end
