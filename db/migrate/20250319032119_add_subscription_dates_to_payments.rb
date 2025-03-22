class AddSubscriptionDatesToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :subscription_start, :datetime
    add_column :payments, :subscription_end, :datetime
  end
end
