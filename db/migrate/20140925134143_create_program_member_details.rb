class CreateProgramMemberDetails < ActiveRecord::Migration
  def change
    create_table :program_member_details do |t|

     t.integer  :run_id
     t.integer  :month_sequence
     t.integer  :member_sequence
	 t.integer  :b_details_sequence
     t.text      :bdm_row_indicator, limit:1
     t.text      :item_type,limit:20
     t.text      :item_source,limit:20
     t.decimal   :dollar_amount, precision: 8, scale: 2
     t.text      :item_countable, limit:1
     t.integer   :calc_method_code
     t.date      :last_calc_month
     t.integer   :lastcalc_incexp_id
     t.integer :created_by , null:false
     t.integer :updated_by , null:false
     t.timestamps
    end
  end
end
