class CreateClientSanctions < ActiveRecord::Migration
  def change
    create_table :client_sanctions do |t|
      t.references :client, index: true,null:false
      t.integer :service_program_id,null:false
      t.integer :sancation_type,null:false
      t.text    :description
      t.date    :infraction_date
      t.date    :effective_beg_date ,null:false
      t.integer :duration,null:false
      t.string  :not_serviced_ind,limit:1
      t.string  :mytodolist_ind,limit:1
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
