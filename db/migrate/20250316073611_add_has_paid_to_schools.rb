class AddHasPaidToSchools < ActiveRecord::Migration[8.0]
  def change
    add_column :schools, :has_paid, :boolean, default: false
  end
end
