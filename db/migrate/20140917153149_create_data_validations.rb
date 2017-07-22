class CreateDataValidations < ActiveRecord::Migration
  def change
    create_table :data_validations do |t|
    	t.integer :client_id,null:false
    	t.string :data_item_type,null:false
    	t.boolean :result,null:false
      	t.timestamps
    end
  end
end
