class DropUnusedTables2 < ActiveRecord::Migration
  def change
  		drop_table :client_sanctions
  		drop_table :client_referrals
  end
end
