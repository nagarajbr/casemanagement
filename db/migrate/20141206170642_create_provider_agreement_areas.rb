class CreateProviderAgreementAreas < ActiveRecord::Migration
  def change
    create_table :provider_agreement_areas do |t|
    	t.references :provider_agreement, index: true, null: false
    	t.integer :served_county
    	t.string :served_area_zip, limit: 5
    	t.integer :created_by , null:false
    	t.integer :updated_by , null:false
      	t.timestamps
    end
  end
end
