class AlterResourcesUseCode < ActiveRecord::Migration
  def up
  	change_column :resources, :use_code, :decimal,precision: 5, scale: 2
  end
end


