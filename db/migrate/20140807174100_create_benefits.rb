class CreateBenefits < ActiveRecord::Migration
  def change
    create_table :benefits do |t|
      t.references :budget_unit, index: true,null:false
      t.integer    :warrant_number
      t.date       :date_of_payment_extract
      t.integer    :payment_type
      t.decimal    :check_amount, precision: 8, scale: 2
      t.integer    :sanction_type
      t.decimal    :grant_amount, precision: 8, scale: 2
      t.decimal    :retro_amount, precision: 8, scale: 2
      t.decimal    :recoup_amount, precision: 8, scale: 2
      t.integer    :county
      t.integer    :service_program_id
      t.integer    :number_of_adults
      t.integer    :number_of_children
      t.integer    :created_by , null:false
      t.integer    :updated_by , null:false
      t.timestamps
    end
  end
end
