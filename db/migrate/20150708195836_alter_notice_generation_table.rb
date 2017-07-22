class AlterNoticeGenerationTable < ActiveRecord::Migration
  def change
  	add_column :notice_generations, :program_unit_id, :integer
  	add_column :notice_generations, :processing_location, :integer
  	add_column :notice_generations, :service_program_id, :integer
  	add_column :notice_generations, :name, :text
  	add_column :notice_generations, :address1, :text
  	add_column :notice_generations, :address2, :text
  	add_column :notice_generations, :city, :text
  	add_column :notice_generations, :state, :text
  	add_column :notice_generations, :zip, :integer
  	add_column :notice_generations, :zip_suffix, :integer
  	add_column :notice_generations, :case_manager_id, :integer
  	add_column :notice_generations, :old_grant, :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :max_benefit, :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :grant_amount, :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :income_limit, :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :def_excess, :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :total_income, :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :gross_earned_income, :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :deducted_amount, :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :child_care_amount, :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :exclusions_amount, :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :net_earned_income, :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :contributions , :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :va_pen , :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :va_comp , :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :va_aa , :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :ssa_bud , :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :ssi_bud , :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :rail_road_retirement , :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :steppar_income , :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :other_unearned_income , :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :total_unearned_income , :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :unearned_exclusion , :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :net_unearned_income , :decimal,precision: 8, scale: 2
  	add_column :notice_generations, :net_countable_income , :decimal,precision: 8, scale: 2
  end
end
