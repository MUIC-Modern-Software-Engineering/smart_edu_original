class RenameOmiseChargeIdToStripe < ActiveRecord::Migration[8.0]
  def change
    rename_column :payments, :omise_charge_id, :stripe_payment_intent_id
  end
end
