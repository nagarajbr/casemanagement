class ApplicationScreening < ActiveRecord::Migration
  def change
  	create_table :application_screenings do |t|
      t.timestamps
    end
  end
end
