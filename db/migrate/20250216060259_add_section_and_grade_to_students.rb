class AddSectionAndGradeToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :section, :string
    add_column :students, :grade, :string
  end
end
