class AddModifyClientTableFields < ActiveRecord::Migration
  def up
  	add_column :clients, :ssn_enumeration_type, :integer
  	add_column :clients, :identification_type, :integer
    add_column :clients, :excempt_from_immunization, :string,limit: 1
    change_column :clients, :ssn, :string, limit: 9, null:false
    change_column :clients, :verfication_doc_type, 'integer USING CAST(verfication_doc_type AS integer)'

  end
end
