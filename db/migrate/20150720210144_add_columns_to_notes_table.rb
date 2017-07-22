class AddColumnsToNotesTable < ActiveRecord::Migration
  def up
  	add_column :notes, :reference_id , :integer, null:false
  end
end
