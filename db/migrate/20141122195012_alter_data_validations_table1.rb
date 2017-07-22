class AlterDataValidationsTable1 < ActiveRecord::Migration
  def change
  	change_column :data_validations, :data_item_type, 'integer USING CAST(data_item_type AS integer)'
  end
end
