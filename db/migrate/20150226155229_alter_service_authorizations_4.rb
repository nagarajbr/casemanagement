class AlterServiceAuthorizations4 < ActiveRecord::Migration
  def change
  		add_column :service_authorizations, :service_date, "date"
  		add_column :service_authorizations, :action_plan_detail_id, "integer"

  end
end
