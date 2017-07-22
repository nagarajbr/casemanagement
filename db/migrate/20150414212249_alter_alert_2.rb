class AlterAlert2 < ActiveRecord::Migration
  def change
  	 add_column :alerts, :status, :integer
  end
end
