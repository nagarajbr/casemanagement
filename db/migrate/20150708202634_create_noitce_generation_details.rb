class CreateNoitceGenerationDetails < ActiveRecord::Migration
  def change
    create_table :notice_generation_details do |t|
    	t.references :notice_generations, index: true, null:false
    	t.text :name
    	t.integer :close_reason
        t.integer :created_by , null:false
        t.integer :updated_by , null:false
        t.timestamps
    end
  end
end
