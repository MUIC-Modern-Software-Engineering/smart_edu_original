class RemoveDefaultClassroomFromStudents < ActiveRecord::Migration[8.0]
  def change
    change_column_default :students, :classroom_id, nil
  end
end
