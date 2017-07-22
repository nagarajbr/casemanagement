class EditUserColumns < ActiveRecord::Migration

  def up
	 remove_column :users, :assign_tasks_ind
	 change_column :users, :location, 'integer USING CAST(location AS integer)'
	 change_column :users, :county, 'integer USING CAST(county AS integer)'
	 change_column :users, :cpu, 'integer USING CAST(cpu AS integer)'
	 change_column :users, :language, 'integer USING CAST(language AS integer)'

  end

  def down
    # add_column :users, :assign_tasks_ind, "char(1)"
	# change_column :users, :location, "char(2)"
	# change_column :users, :county, "char(2)"
	# change_column :users, :cpu, "varchar(3)"
	# change_column :users, :language, "char(2)"
  end

end
