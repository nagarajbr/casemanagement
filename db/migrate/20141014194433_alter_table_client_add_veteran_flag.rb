class AlterTableClientAddVeteranFlag < ActiveRecord::Migration
  def up
  	add_column :clients, :veteran_flag, :string, limit: 1
  end
end
