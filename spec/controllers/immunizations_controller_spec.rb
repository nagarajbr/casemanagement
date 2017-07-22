require 'rails_helper'
require 'spec_helper'

# rspec spec/controllers/immunizations_controller_spec.rb -fd
RSpec.describe ImmunizationsController, :type => :controller do
	# Manoj Patil 08/11/2014.
	# For AUthlogic authentication 
	setup :activate_authlogic

	# 1.
	describe "GET #show" do 
		
		before :each do 
			# Fake Login
	 		fake_login()
	 		# left side - set up data
			@arg_client = FactoryGirl.create(:client,dob:"2001-01-15") 
			# @arg_immunization = FactoryGirl.create(:immunization,client: @arg_client,date_administered:"2012-01-15")
			# Right side - controller needs session[:CLIENT_ID] needs to be populated.
			session[:CLIENT_ID] = @arg_client.id
		end 



		it "show Total number vaccinations in param table(19) records(records from database + records in memory) on the show page." do
			total_number_of_vaccinations = SystemParam.param_values_list(2,"Vaccination List").size
			arg_p = FactoryGirl.create(:immunization,client: @arg_client,date_administered:"2001-03-01")
			# expected value - Right side of comparison -hitting the controller code.
	 		get :show
	 		# Test
		 	assigns(:immunizations).size.should == total_number_of_vaccinations
		end
 
		it "shows vaccinations from database if date administered is entered." do
			#  left side
			#  create a record for client.
			arg_client = FactoryGirl.create(:client,ssn:"987651234",dob:"2001-01-20")
			arg_p = FactoryGirl.create(:immunization,client: arg_client,date_administered:"2001-03-01")
			session[:CLIENT_ID] = arg_client.id
	 		
			#  right side
			get :show
			#  test
			#  first vaccination type(2) is inserted in the factor - hence I know first record in the collection will be record from database.
			assigns(:immunizations).first.date_administered.should == arg_p.date_administered
			# a = assigns(:immunizations)
			# puts "a.inspect= #{a.inspect}"
			# 1.should == 1
		end

		it "shows vaccinations from built record in memory if date administered is not entered." do
			#  left side
			#  create a record for client.
			arg_client = FactoryGirl.create(:client,ssn:"987651234",dob:"2001-01-20")
			arg_p = FactoryGirl.create(:immunization,client: arg_client,date_administered:"2001-03-01")
			session[:CLIENT_ID] = arg_client.id
	 		
			#  right side
			get :show
			#  test
			#  first vaccination type(2) is inserted in the factor - hence I know first record in the collection will be record from database.
			assigns(:immunizations).last.date_administered.should == nil
			# a = assigns(:immunizations)
			# puts "a.inspect= #{a.inspect}"
			# 1.should == 1
		end

		
		

	end 

	
	# 2.
	describe "GET #new" do 
		it "builds 19 new immunizations objects for selected client to @immunizations to be shown on New template." do
			# Fake Login
	 		fake_login()
	 		# Left side
	 		arg_client = FactoryGirl.create(:client,ssn:"987651234",dob:"2001-01-20")
	 		total_number_of_vaccinations = SystemParam.param_values_list(2,"Vaccination List").size

	 		# Right side
	 		session[:CLIENT_ID] = arg_client.id
	 		get :new
	 		# Test
	 		assigns(:immunizations).size.should == total_number_of_vaccinations
		end
	end 


	# 3.
	describe "POST #create" do 
		before :each do 
			# Fake Login
	 		 fake_login()
	 		 # left side - set up client test data
	 		 @arg_client = FactoryGirl.create(:client,ssn:"987651234",dob:"2001-01-20")
	 		 # right side controller needs session[:CLIENT_ID]
	 		 session[:CLIENT_ID] = @arg_client.id
	 		 @params_array = 	[ {"provider_id"=>"",
								 "date_administered"=>"2014-01-01",
								 "vaccine_type"=>"2",
								 "client_id"=>"1362",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 },
								 {"provider_id"=>"",
								 "date_administered"=>"",
								 "vaccine_type"=>"3",
								 "client_id"=>"1362",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								}
							  ]
			 @params_array_invalid = 	[ {"provider_id"=>"",
								 "date_administered"=>"0001-01-01",
								 "vaccine_type"=>"",
								 "client_id"=>"1362",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 }
							  ]				  

		end

		context "with valid attributes" do 
			#4.
			it "saves the new immunization object in the database if date administered is entered." do
				
	 			# Test
				expect{ post :create, immunizations: @params_array 
					  }.to change(Immunization,:count).by(1) 
			end
			#5.
			it "redirects to the show page after successful creation." do
				 post :create, immunizations: @params_array 
				 response.should redirect_to show_immunizations_path

			end
		end 

		context "with invalid attributes" do 
			#5.
			it "does not save the new immunization object in the database" do
				
				expect{ post :create, immunizations: @params_array_invalid 
				      }.to_not change(Immunization,:count) 
			end
			#6.
			it "re-renders the :new template when creation is failed." do
				
				post :create, immunizations: @params_array_invalid  
				response.should render_template :new 
			end
		end 
	end	


	describe 'PUT update' do
		before :each do 
			# Fake Login
	 		fake_login()
	 		@arg_client = FactoryGirl.create(:client,ssn:"987651234",dob:"2001-01-20")
	 		session[:CLIENT_ID] = @arg_client.id
	 		@arg_immunization = FactoryGirl.create(:immunization,client: @arg_client,date_administered:"2001-03-01")
	 	end

	 	context "valid attributes" do 
	 		it "Updates the Model successfully with valid attributes" do 
	 			# changed date_administered from 2001-03-01 to 2001-04-01
				# Left side
				immunization_id = @arg_immunization.id
				
				change_immunization = 	{
										"#{immunization_id}" =>
											 {"date_administered"=>"2001-04-01",
											  "updated_by"=>"21"
											 }
								        }
				# Right side
				put :update, immunizations:change_immunization
				# get the record from database.
				
				im_record = Immunization.find(immunization_id)
				# # test
				# right side == left side
				im_record.date_administered.should == "2001-04-01".to_date
	 		end

	 		it "Inserts new record if new vaccination is entered with valid date administered value" do 
	 			# changed date_administered from 2001-03-01 to 2001-04-01
				# Left side
				immunization_id = @arg_immunization.id
				
				new_immunization = 	{
										"-1" =>
											 {"provider_id"=>"",
											 "date_administered"=>"2001-02-01",
											 "vaccine_type"=>"3",
											 "client_id"=>"#{ @arg_client.id}",
											 "created_by"=>"21",
											 "updated_by"=>"21"
											 }
								        }
				# Right side
				put :update, immunizations:new_immunization
				# get the record from database.
				
				im_record = @arg_client.immunizations.last
				# # test
				# right side == left side
				im_record.date_administered.should == "2001-02-01".to_date
	 		end

	 		it "deletes record if existing vaccination's date administered is set to null" do 
	 			immunization_id = @arg_immunization.id
				count_before =  @arg_client.immunizations.size
				delete_immunization = 	{
										"#{immunization_id}" =>
											 {"date_administered"=>nil,
											  "updated_by"=>"21"
											 }
								        }
				# Right side
				put :update, immunizations:delete_immunization
				# get the record from database.
				count_after =  @arg_client.immunizations.size
				
				# # test
				# right side == left side
				(count_before -1).should == count_after
	 		end


	 	end

	 	context "invalid attributes" do 
	 		it "does not update immunization object when invalid attributes are passed." do 
	 			# changed date_administered from 2001-03-01 to 0001-04-01
	 			#  so after unsuccessful update - data should be still 2001-03-01
				# Left side
				immunization_id = @arg_immunization.id
				
				change_immunization = 	{
										"#{immunization_id}" =>
											 {"date_administered"=>"0001-04-01",
											  "updated_by"=>"21"
											 }
								        }
				# Right side
				put :update, immunizations:change_immunization
				# get the record from database.
				
				im_record = Immunization.find(immunization_id)
				# # test
				# right side == left side
				# from database before update is 2001-03-01 
				im_record.date_administered.should == "2001-03-01".to_date
	 		end


	 	end

	end



	def fake_login
		 @user = FactoryGirl.create(:user)
	     @user_session = FactoryGirl.create(:user_session)
	end

end
