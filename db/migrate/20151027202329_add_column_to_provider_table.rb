class AddColumnToProviderTable < ActiveRecord::Migration
  def change
  	add_column :providers, :fms_reviewer_id, :string
  end
end
