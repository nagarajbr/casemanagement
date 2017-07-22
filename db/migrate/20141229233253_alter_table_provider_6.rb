class AlterTableProvider6 < ActiveRecord::Migration
  def up
  	add_column :providers, :head_office_provider_id, :integer
  end
end
