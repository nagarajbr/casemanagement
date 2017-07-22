class AlterUser2 < ActiveRecord::Migration
  def change
  	 change_column :users, :permissions, :string ,array:true
  end
end
