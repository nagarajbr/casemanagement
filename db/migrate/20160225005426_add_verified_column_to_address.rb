class AddVerifiedColumnToAddress < ActiveRecord::Migration
  def change
  	add_column :addresses, :verified, :string ,limit:1
  end
end
