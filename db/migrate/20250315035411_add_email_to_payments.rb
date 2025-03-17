class AddEmailToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :email, :string
  end
end
