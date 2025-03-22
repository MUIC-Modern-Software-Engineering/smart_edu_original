class AddTierToSchool < ActiveRecord::Migration[8.0]
  def change
    add_column :schools, :tier, :integer, default: 1
  end
end
