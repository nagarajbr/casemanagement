class CreateProviderServiceAreas < ActiveRecord::Migration
  def change
    create_table :provider_service_areas do |t|
    	t.references :provider_service, index: true, null: false
	    t.string :area_zip, limit: 5 ,null: false
	    t.integer :created_by , null:false
	    t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
