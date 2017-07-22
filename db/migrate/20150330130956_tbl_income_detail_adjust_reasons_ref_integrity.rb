class TblIncomeDetailAdjustReasonsRefIntegrity < ActiveRecord::Migration
  def change
  	change_column :income_detail_adjust_reasons, :income_detail_id, :integer, null:false
  	change_column :income_detail_adjust_reasons, :adjusted_amount, :decimal, precision: 8, scale: 2, null:false

  	 execute <<-SQL
    	ALTER TABLE income_detail_adjust_reasons
		ADD CONSTRAINT incm_dtl_adj_rsn_income_detail_id_fkey
		    FOREIGN KEY (income_detail_id)
		    REFERENCES income_details(id);
     SQL


  end
end
