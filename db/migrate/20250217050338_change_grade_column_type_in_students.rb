class ChangeGradeColumnTypeInStudents < ActiveRecord::Migration[8.0]
  def change
    change_column :students, :grade, :integer
  end
end
