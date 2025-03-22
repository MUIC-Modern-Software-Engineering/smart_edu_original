class DropPaymentsTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :payments
  end

  def down
    create_table :payments do |t|
      t.integer :amount, null: false
      t.string :status, null: false
      t.string :stripe_payment_intent_id, null: false
      t.references :user, null: false, foreign_key: true
      t.timestampse
    end
  end
end
