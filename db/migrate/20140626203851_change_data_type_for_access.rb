class ChangeDataTypeForAccess < ActiveRecord::Migration
  def change
  	change_column :access_rights, :access, "char(2)"
  end
end
