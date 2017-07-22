class AlterClientAddQuestionFlags < ActiveRecord::Migration
  def change
  	add_column :clients, :education_add_flag, :string, limit: 1
  	add_column :clients, :earned_income_flag, :string, limit: 1
  	add_column :clients, :job_offer_flag, :string, limit: 1
  	add_column :clients, :unearned_income_flag, :string, limit: 1
  	add_column :clients, :expense_add_flag, :string, limit: 1
  	add_column :clients, :resource_add_flag, :string, limit: 1

  end
end
