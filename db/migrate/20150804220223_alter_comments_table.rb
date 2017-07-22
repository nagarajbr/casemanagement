class AlterCommentsTable < ActiveRecord::Migration
  def change
  	remove_column :comments, :notes
  	add_column :comments, :comment, :text
  end
end
