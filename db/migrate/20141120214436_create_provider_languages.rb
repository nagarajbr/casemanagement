class CreateProviderLanguages < ActiveRecord::Migration
  def change
    create_table :provider_languages do |t|
    	t.integer :provider_id
    	t.integer :language_type
    	t.date :start_date
		t.date :end_date
		t.integer :created_by , null:false
	    t.integer :updated_by , null:false
	    t.timestamps
    end
  end
end
