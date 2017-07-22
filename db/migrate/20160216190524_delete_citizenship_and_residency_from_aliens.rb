class DeleteCitizenshipAndResidencyFromAliens < ActiveRecord::Migration
  def change
  	remove_column :aliens, :residency
    remove_column :aliens, :citizenship
  end
end
