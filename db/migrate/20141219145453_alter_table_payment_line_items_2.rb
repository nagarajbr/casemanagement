class AlterTablePaymentLineItems2 < ActiveRecord::Migration
  def up
  	add_column :payment_line_items, :paid_date, :date
  end
end
