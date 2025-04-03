class AddSoftDeleteStudent < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :discarded_at, :datetime
    add_index :students, :discarded_at
  end
end
