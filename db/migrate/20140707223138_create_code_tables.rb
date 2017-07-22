class CreateCodeTables < ActiveRecord::Migration
  def change
    create_table :code_tables do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
