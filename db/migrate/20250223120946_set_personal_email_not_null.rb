class SetPersonalEmailNotNull < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      UPDATE users
      SET personal_email = email_address
      WHERE personal_email IS NULL;
    SQL

    change_column_null :users, :personal_email, false
  end

  def down
    change_column_null :users, :personal_email, true
  end
end
