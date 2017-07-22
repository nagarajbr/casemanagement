class CreateWadcTemps < ActiveRecord::Migration
  def change
    create_table :wadc_temps do |t|
   t.string :case_no, limit: 7
   t.string :payment_month, limit: 4
   t.string :payment_type, limit: 2
   t.string :pay_date, limit: 6
   t.string :check_amount, limit: 4
   t.string :warrant_no, limit: 6
   t.string :action_date, limit: 8
   t.string :action_ind, limit: 1
   t.string :sanction, limit: 1
   t.string :category, limit: 2
   t.string :recoupment, limit: 9
   t.timestamps
    end
  end
end
