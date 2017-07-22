class AlterUsersTable < ActiveRecord::Migration
  def change
  	rename_column :users, :email_id, :email
  	add_column :users, :uid, :string
  	add_column :users, :organisation_slug, :string
  	add_column :users, :organisation_content_id, :string
  	add_column :users, :permissions, :integer ,array:true
  	add_column :users, :remotely_signed_out, :boolean, :default => "N"
  	add_column :users, :disabled, :boolean, :default => "N"
  end
end