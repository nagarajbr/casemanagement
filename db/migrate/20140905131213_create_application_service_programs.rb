class CreateApplicationServicePrograms < ActiveRecord::Migration
  def change
    create_table :application_service_programs do |t|
    		t.references :client_application, index: true, null: false
    		t.references :service_program, index: true, null: false
    		t.string  :status, limit: 1, null: false
    		t.integer :created_by , null:false
    		t.integer :updated_by , null:false
	      t.timestamps
    end
  end
end
