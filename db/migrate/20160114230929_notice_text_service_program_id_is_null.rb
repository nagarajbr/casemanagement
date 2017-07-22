class NoticeTextServiceProgramIdIsNull < ActiveRecord::Migration
  def change
  	  change_column :notice_texts, :service_program_id, :integer, null:true
  end
end
