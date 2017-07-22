class CreateProgramStandardDetails < ActiveRecord::Migration
  def change
    create_table :program_standard_details do |t|
      t.references :program_standard, index: true, null:false
      t.date       :effective_date,null:false
      t.decimal    :program_standard_limit_amount,precision: 8, scale: 2
      t.decimal    :program_standard_max_shelter,precision: 8, scale: 2
      t.integer    :created_by , null:false
      t.integer    :updated_by , null:false
      t.timestamps
    end
  end
end
