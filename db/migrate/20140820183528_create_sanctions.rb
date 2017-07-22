class CreateSanctions < ActiveRecord::Migration
  def change
    create_table :sanctions do |t|
      t.references :client, index: true, null:false
      t.references :service_program, index: true, null:false
      t.integer :sanction_type, null:false
      t.string :description, limit: 255
      t.date    :infraction_date
      t.date :effective_begin_date, null:false
      t.integer :duration_type, null:false
      t.string :not_serviced_indicator, limit: 1
      t.string :mytodolist_indicator, limit: 1
      t.integer :created_by , null:false
   	  t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
