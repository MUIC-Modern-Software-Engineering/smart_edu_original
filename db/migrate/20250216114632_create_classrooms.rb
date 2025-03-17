class CreateClassrooms < ActiveRecord::Migration[8.0]
  def change
    create_table :classrooms do |t|
      t.string :class_id, null: false
      t.integer :grade_level, null: false

      t.timestamps
    end
    add_index :classrooms, :class_id, unique: true
  end
end
