class AddUniqueIndexToClassrooms < ActiveRecord::Migration[8.0]
  def change
    add_index :classrooms, [ :school_id, :class_id ], unique: true
  end
end
