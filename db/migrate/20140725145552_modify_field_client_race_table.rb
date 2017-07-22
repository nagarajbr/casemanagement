class ModifyFieldClientRaceTable < ActiveRecord::Migration
 def self.up
    rename_column :client_races, :race_type, :race_id
  end
end
