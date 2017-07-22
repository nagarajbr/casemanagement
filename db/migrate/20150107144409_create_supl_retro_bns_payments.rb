class CreateSuplRetroBnsPayments < ActiveRecord::Migration
  def change
    create_table :supl_retro_bns_payments do |t|
       t.references :program_units, index: true
       t.integer :payment_type
       t.date  :payment_month
       t.integer  :status
       t.decimal :payment_amount, precision: 8, scale: 2
       t.integer :payment_status
       t.string  :reason
       t.integer :created_by , null:false
       t.integer :updated_by , null:false
       t.timestamps
    end
  end
end
