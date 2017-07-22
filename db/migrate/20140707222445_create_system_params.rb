class CreateSystemParams < ActiveRecord::Migration
  def change
    create_table :system_params do |t|
      t.references :system_param_categories, index: true
      t.string :key
      t.string :value
      t.text    :description, limit:255
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
