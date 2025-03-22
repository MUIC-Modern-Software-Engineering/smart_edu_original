class DropGradesTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :grades, if_exists: true
  end
end
