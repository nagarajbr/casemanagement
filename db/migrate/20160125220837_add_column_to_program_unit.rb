class AddColumnToProgramUnit < ActiveRecord::Migration
  def change
  	 add_column :program_units, :deny_notice_generation_flag , "char(1)"
  end
end
