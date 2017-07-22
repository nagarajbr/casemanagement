class AddFieldsToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :name, "varchar(50)"
    add_reference :users, :role, index: true
    add_column :users, :title, "varchar(35)"
    add_column :users, :location, "char(2)"
    add_column :users, :status, "char(1)"
    add_column :users, :phone_area_code, "char(3)"
    add_column :users, :phone_prefix, "char(3)"
    add_column :users, :phone_term, "char(4)"
    add_column :users, :phone_ext, "char(4)"
    add_column :users, :language, "char(2)"
    add_column :users, :created_by_user_id, :integer
    add_column :users, :updated_by_user_id, :integer
    add_column :users, :last_passwd_change_at, :datetime
    add_column :users, :county, "char(2)"
    add_column :users, :assign_tasks_ind, "char(1)"
    add_column :users, :active_directory_id, "varchar(50)"
    add_column :users, :asis_emp_num, "varchar(10)"
    add_column :users, :division_code, "char(10)"
    add_column :users, :email, "varchar(50)"
    add_column :users, :cpu, "varchar(3)"

  end
end
