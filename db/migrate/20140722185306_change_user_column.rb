class ChangeUserColumn < ActiveRecord::Migration
  def self.up
    rename_column :users, :created_by_user_id, :created_by
    rename_column :users, :updated_by_user_id, :updated_by
  end

  def self.down
    rename_column :users, :created_by, :created_by_user_id
    rename_column :users, :updated_by, :updated_by_user_id
  end
end
