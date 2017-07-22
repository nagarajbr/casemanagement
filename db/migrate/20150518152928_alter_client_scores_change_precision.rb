class AlterClientScoresChangePrecision < ActiveRecord::Migration
  def change
  	change_column :client_scores, :scores, :decimal, precision: 5, scale: 2
  end
end
