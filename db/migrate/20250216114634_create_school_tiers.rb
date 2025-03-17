class CreateSchoolTiers < ActiveRecord::Migration[8.0]
  def change
    create_table :school_tiers do |t|
      t.references :school, null: false, foreign_key: true
      t.string :tier, null: false

      t.timestamps
    end
  end
end
