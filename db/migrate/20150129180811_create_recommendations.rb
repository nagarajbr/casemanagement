class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.text :recommendation_text, null:false
      t.text :comments
      t.integer :created_by , null:false
	  t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
