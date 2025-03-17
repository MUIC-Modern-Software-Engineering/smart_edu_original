class CreateHomerooms < ActiveRecord::Migration[8.0]
  def change
    create_table :homerooms do |t|
      t.references :teacher, null: false, foreign_key: { to_table: :users }
      t.references :classroom, null: false, foreign_key: true

      t.timestamps
    end
  end
end
