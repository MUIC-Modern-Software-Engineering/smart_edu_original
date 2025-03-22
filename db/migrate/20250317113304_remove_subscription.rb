class RemoveSubscription < ActiveRecord::Migration[8.0]
  def change
    remove_column :payments, :stripe_subscription_id, :string
  end
end
