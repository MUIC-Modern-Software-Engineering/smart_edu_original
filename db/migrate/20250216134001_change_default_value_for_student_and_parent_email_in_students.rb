class ChangeDefaultValueForStudentAndParentEmailInStudents < ActiveRecord::Migration[8.0]
  def change
    change_column_default :students, :student_email_address, "student@example.com"
    change_column_default :students, :parent_email_address, "parent@example.com"
  end
end
