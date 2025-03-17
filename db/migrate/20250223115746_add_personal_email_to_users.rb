class AddPersonalEmailToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :personal_email, :string # No null constraint yet
  end
end
