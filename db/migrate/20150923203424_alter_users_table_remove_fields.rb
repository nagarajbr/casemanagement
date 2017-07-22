class AlterUsersTableRemoveFields < ActiveRecord::Migration
  def change
  	 remove_column :users, :login
  	 remove_column :users, :crypted_password
  	 remove_column :users, :password_salt
  	 remove_column :users, :persistence_token
  	 remove_column :users, :single_access_token
  	 remove_column :users, :perishable_token
  	 remove_column :users, :login_count
  	 remove_column :users, :failed_login_count
  	 remove_column :users, :last_request_at
  	 remove_column :users, :current_login_at
  	 remove_column :users, :last_login_at
  	 remove_column :users, :current_login_ip
  	 remove_column :users, :last_login_ip
  	 remove_column :users, :title
  	 remove_column :users, :location
  	 remove_column :users, :status
  	 remove_column :users, :language
  	 remove_column :users, :last_passwd_change_at
  	 remove_column :users, :cpu
  	 remove_column :users, :reports_to

  end
end




