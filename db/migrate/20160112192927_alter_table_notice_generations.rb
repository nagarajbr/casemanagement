class AlterTableNoticeGenerations < ActiveRecord::Migration
  def change
  	rename_column :notice_generations, :program_unit_id, :reference_id
  	add_column :notice_generations, :reference_type, :integer
  	rename_column :primary_contacts, :entity_id, :reference_id
  	rename_column :primary_contacts, :entity_type, :reference_type
  end
end
