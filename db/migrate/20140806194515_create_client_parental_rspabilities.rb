class CreateClientParentalRspabilities < ActiveRecord::Migration
  def change
    create_table :client_parental_rspabilities do |t|
      t.references :client_relationship, index: true,null:false
      t.decimal :amount_collected, precision: 8, scale: 2
      t.decimal :court_ordered_amount, precision: 8, scale: 2
      t.string  :good_cause, limit:1
      t.string  :married_at_birth, limit:1
      t.string  :paternity_established, limit:1
      t.string  :court_order_number,limit:10
      t.integer :deprivation_code
      t.integer :child_support_referral
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
