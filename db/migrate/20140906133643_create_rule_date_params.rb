class CreateRuleDateParams < ActiveRecord::Migration
  def change
    create_table :rule_date_params do |t|
    	t.integer :code_table_id
        t.integer :codetable_item_id
        t.text    :description , limit:25
        t.integer :domain_id
        t.text :datetype_conversion , limit:10
        t.integer :correspdate_value
        t.text    :uniqueness_ind, limit:1
        t. text    :business_objects, limit:30
        t.integer :created_by , null:false
	    t.integer :updated_by , null:false
	    t.timestamps
    end
  end
end
