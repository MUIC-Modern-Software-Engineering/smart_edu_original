class CreateGrades < ActiveRecord::Migration[8.0]
  def change
    create_table :grades do |t|
      t.integer :level

      t.timestamps
    end
  end
end
