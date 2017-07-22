class AddClientEmail < ActiveRecord::Migration
  def up
  	add_column :clients, :client_email, :string
  end
end
