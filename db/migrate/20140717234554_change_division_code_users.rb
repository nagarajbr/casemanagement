class ChangeDivisionCodeUsers < ActiveRecord::Migration
  def up
	 change_column :users, :division_code, 'integer USING CAST(division_code AS integer)'

  end

  def down

  end
end
