class RemoveUniqueConstraintFromClassId < ActiveRecord::Migration[8.0]
  def change
    remove_index :classrooms, :class_id
  end
end
