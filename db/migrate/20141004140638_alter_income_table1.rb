class AlterIncomeTable1 < ActiveRecord::Migration
  def up
  	change_column :incomes, :source, :string, limit: 50
  end
end
