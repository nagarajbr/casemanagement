class AlterAlertsAddColumn2 < ActiveRecord::Migration
  def change
  	 add_column :alerts, :information_only, "char(1)"
  end
end
