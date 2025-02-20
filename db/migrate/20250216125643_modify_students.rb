class ModifyStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :student_email_address, :string, default: "student@example.com", null: false
    add_column :students, :parent_email_address, :string, default: "parent@example.com", null: false
    add_reference :students, :classroom, foreign_key: true, default: 0, null: false
    add_foreign_key :students, :users, column: :student_email_address, primary_key: :email_address
  end
end
