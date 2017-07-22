namespace :import_from_csv_file do
	desc "Import from csv file to table import_data_from_files"
	task :csv_to_import_data_from_files => :environment do
		require 'csv'
		CSV.foreach('C:/ATTOP_MAIN/csv_files/import_test_data.csv') do |arg_row|
			# puts arg_row.inspect
			l_name = arg_row[0]
			l_age = arg_row[1].to_i
			ImportDataFromFile.create(name: l_name,age: l_age)
		end	
	end
end 