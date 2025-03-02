class AddIsActiveToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :is_active, :boolean, default: true, null: false
  end
end
