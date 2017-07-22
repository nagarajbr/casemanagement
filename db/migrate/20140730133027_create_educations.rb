class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
    t.references :client, index: true,null:false
    t.integer :school_type
    t.integer :school_name
    t.integer :attendance_type
    t.text    :school_address_1, limit: 30
    t.text    :school_address_2, limit: 30
	t.date    :effective_beg_date
	t.date    :effective_end_date
	t.text	  :major_study , limit: 25
	t.integer :high_grade_level , null: false
    t.date    :expected_grad_date
    t.integer :degree_obtained
    t.text    :effort, limit: 3
    t.integer :created_by , null:false
    t.integer :updated_by , null:false
    t.timestamps
    end
  end
end
