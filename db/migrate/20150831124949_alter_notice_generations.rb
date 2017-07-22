class AlterNoticeGenerations < ActiveRecord::Migration
  def change
  	add_column :notice_generations, :program_wizard_id, :integer
  end
end
