class AlterTableProvider1 < ActiveRecord::Migration
  def up
  	change_column :providers, :notes,:text
  end
end
