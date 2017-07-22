class CreateProviderAgreements < ActiveRecord::Migration
  def change
    create_table :provider_agreements do |t|
    	t.references :provider, index: true, null: false
    	t.references :provider_service, index: true, null: false
     	t.integer :dws_local_office_id, null: false
      t.integer :dws_local_office_manager_id, null: false
    	t.date    :agreement_start_date, null: false
  		t.date    :agreement_end_date, null: false
	   	t.integer :created_by , null:false
    	t.integer :updated_by , null:false
      t.timestamps
    end
  end
end