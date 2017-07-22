class CreateStandardRecommendations < ActiveRecord::Migration
  def change
    create_table :standard_recommendations do |t|
      t.integer :barrier_id, null:false
      t.integer :recommendation_id, null:false
      t.integer :created_by , null:false
	  t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
