class CreatePrincipalTeacherRelationships < ActiveRecord::Migration[8.0]
  def change
    create_table :principal_teacher_relationships do |t|
      t.references :principal, null: false, foreign_key: { to_table: :users }
      t.references :teacher, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
