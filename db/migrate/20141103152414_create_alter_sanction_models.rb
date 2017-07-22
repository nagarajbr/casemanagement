class CreateAlterSanctionModels < ActiveRecord::Migration

def up
  	remove_column :sanctions, :effective_begin_date
  	remove_column :sanctions, :duration_type
  	remove_column :sanctions, :not_serviced_indicator
  	remove_column :sanctions, :infraction_date
    add_column :sanctions, :infraction_begin_date, :date
  	add_column :sanctions, :infraction_end_date, :date
  end
end