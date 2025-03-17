class RemoveSectionFromStudents < ActiveRecord::Migration[8.0]
  def change
    remove_column :students, :section, :string
  end
end
