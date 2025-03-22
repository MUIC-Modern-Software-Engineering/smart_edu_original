class CreatePaymentsStripe < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.integer :amount, null: false
      t.string :status, null: false, default: 'pending'
      t.string :stripe_payment_intent_id, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
