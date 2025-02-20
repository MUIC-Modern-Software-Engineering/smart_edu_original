class CreateTeacherStudentRelationships < ActiveRecord::Migration[8.0]
  def change
    create_table :teacher_student_relationships do |t|
      t.references :teacher, null: false, foreign_key: { to_table: :users }
      t.references :student, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
