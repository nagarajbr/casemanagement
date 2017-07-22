class CreateTepcTemps < ActiveRecord::Migration
  def change
    create_table :tepc_temp do |t|
   t.string :ssn, limit: 9
   t.string :fed, limit: 2
   t.string :tea, limit: 2
   t.string :skip, limit: 2
   t.string :pay_month, limit: 6
   t.string :pat_type, limit: 2
   t.string :pay_date, limit: 8
   t.string :pay_amount, limit: 4
   t.string :case_no, limit: 7
   t.string :wp_reson, limit: 2
   t.string :state, limit: 2
   t.string :work_pay, limit: 2
   t.timestamps
    end
  end
end
