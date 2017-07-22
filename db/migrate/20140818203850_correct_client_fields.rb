class CorrectClientFields < ActiveRecord::Migration
  def up
  	 rename_column :clients, :excempt_from_immunization, :exempt_from_immunization
  	 rename_column :clients, :sex, :gender
 	 remove_column :clients, :exempt
  end
end
