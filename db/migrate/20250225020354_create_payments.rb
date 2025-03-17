class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount
      t.string :omise_charge_id
      t.string :status

      t.timestamps
    end
  end
end
