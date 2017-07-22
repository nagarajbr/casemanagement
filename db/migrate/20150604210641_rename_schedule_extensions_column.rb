class RenameScheduleExtensionsColumn < ActiveRecord::Migration
  def change
  	rename_column :schedule_extensions, :extended_duration, :extension_duration
  end
end
