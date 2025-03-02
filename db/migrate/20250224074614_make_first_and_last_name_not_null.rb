class MakeFirstAndLastNameNotNull < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      UPDATE users
      SET first_name = 'DefaultFirstName'
      WHERE first_name IS NULL;
    SQL

    execute <<-SQL
      UPDATE users
      SET last_name = 'DefaultLastName'
      WHERE last_name IS NULL;
    SQL

    change_column_null :users, :first_name, false, 'DefaultFirstName'
    change_column_null :users, :last_name, false, 'DefaultLastName'
  end

  def down
    change_column_null :users, :first_name, true
    change_column_null :users, :last_name, true
  end
end
