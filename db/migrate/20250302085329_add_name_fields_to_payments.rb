class AddNameFieldsToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :first_name, :string
    add_column :payments, :last_name, :string
  end
end
