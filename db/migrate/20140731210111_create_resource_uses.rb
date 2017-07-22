class CreateResourceUses < ActiveRecord::Migration
  def change
    create_table :resource_uses do |t|
    t.references :resource_details, index: true,null:false
    t.integer :usage_code
    t.integer :created_by , null:false
    t.integer :updated_by , null:false
    t.timestamps
    end
  end
end
