class CreateClientScores < ActiveRecord::Migration
  def change
    create_table :client_scores do |t|

     t.references :client, index: true
      t.integer :test_type
      t.date    :date_referred
      t.date :date_test_taken_on
      t.decimal :scores, precision: 4, scale: 1
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
