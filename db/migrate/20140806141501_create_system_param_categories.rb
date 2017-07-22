class CreateSystemParamCategories < ActiveRecord::Migration
  def change
    create_table :system_param_categories do |t|

      t.text    :description, limit:255
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
           