class AddUniqueIndexToSchoolsName < ActiveRecord::Migration[8.0]
  def change
    add_index :schools, :name, unique: true
  end
end
