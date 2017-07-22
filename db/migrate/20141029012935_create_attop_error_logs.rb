class CreateAttopErrorLogs < ActiveRecord::Migration
  def change
    create_table :attop_error_logs do |t|
    	t.string :object_name
    	t.string :method_name
    	t.string :error_message
    	t.text :trace_details
    	t.integer :created_by , null:false

      t.timestamps
    end
  end
end
