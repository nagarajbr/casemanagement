require 'rails_helper'

# rspec spec/controllers/addresses_controller_spec.rb -fd
RSpec.describe AddressesController, :type => :controller do
	# Manoj Patil 08/11/2014.
	# For AUthlogic authentication 
	setup :activate_authlogic

	# 1.
	describe "GET #show" do 
		
		before :each do 
			# Fake Login
	 		fake_login()
	 		# left side - set up data
			@arg_client = FactoryGirl.create(:client) 
			# @arg_immunization = FactoryGirl.create(:immunization,client: @arg_client,date_administered:"2012-01-15")
			# Right side - controller needs session[:CLIENT_ID] needs to be populated.
			session[:CLIENT_ID] = @arg_client.id
		end 



		it "show Mailing and Residential Address for the selected client, if address records are in database." do
			# create mailing address
			arg_m = FactoryGirl.create(:address,address_type: 4665)
			arg_mc = ClientAddress.create(address_id: arg_m.id,client_id: @arg_client.id)

			# create residence address
			arg_r = FactoryGirl.create(:address,address_type: 4664)
			arg_rc = ClientAddress.create(address_id: arg_r.id,client_id: @arg_client.id)
			# expected value - Right side of comparison -hitting the controller code.
	 		get :show
	 		# Test
		 	assigns(:addresses).size.should == 2
		end

	end	

	# 2.
	describe "GET #new" do 
		it "builds 2 new address objects for selected client to @addresses to be shown on New template." do
			# Fake Login
	 		fake_login()
	 		# Left side
	 		arg_client = FactoryGirl.create(:client)
	 		addresses = arg_client.addresses
	 		arg_m = FactoryGirl.build(:address,address_type: 4665)
	 		arg_r = FactoryGirl.build(:address,address_type: 4664)
	 		addresses << arg_m
	 		addresses << arg_r


	 		# Right side
	 		session[:CLIENT_ID] = arg_client.id
	 		get :new
	 		# Test
	 		assigns(:addresses).size.should == addresses.size
		end
	end 


	# 3.
	describe "POST #create" do 
		before :each do 
			# Fake Login
	 		 fake_login()
	 		 # left side - set up client test data
	 		 @arg_client = FactoryGirl.create(:client)
	 		 # right side controller needs session[:CLIENT_ID]
	 		 session[:CLIENT_ID] = @arg_client.id

	 		 @params_array = 	[ {"address_type"=>"4664",
								 "address_line1"=>"1501 Chenal Parkway",
								 "city"=>"Little Rock",
								 "state"=>"4667",
								 "zip"=>"72223"
								 },
								 {"address_type"=>"4665",
								 "address_line1"=>"2 Capitol Ave",
								 "city"=>"Little Rock",
								 "state"=>"4667",
								 "zip"=>"72223"
								}
							  ]
			 @params_array_invalid = 	[ {"address_type"=>"4664",
								 "address_line1"=>"",
								 "city"=>"",
								 "state"=>"",
								 "zip"=>""
								 }
							  ]				  

		end

		context "with valid attributes" do 
			#4.
			it "saves 2 new address (Mailing and Residence) object in the database if valid address data is entered." do
				
	 			# Test
				expect{ post :create, addresses: @params_array 
					  }.to change(Address,:count).by(2) 
			end
			#5.
			it "redirects to the show page after successful address records creation." do
				 post :create, addresses: @params_array 
				 response.should redirect_to show_address_path

			end
		end 

		context "with invalid attributes" do 
			#5.
			it "does not save the new address object in the database" do
				
				expect{ post :create, addresses: @params_array_invalid 
				      }.to_not change(Address,:count) 
			end
			#6.
			it "re-renders the :new template when creation is failed." do
				
				post :create, addresses: @params_array_invalid  
				response.should render_template :new 
			end
		end 
	end	

	describe 'PUT update' do
		before :each do 
			# Fake Login
	 		fake_login()
	 		@arg_client = FactoryGirl.create(:client)
	 		session[:CLIENT_ID] = @arg_client.id
	 		# create mailing address
			@arg_m = FactoryGirl.create(:address,address_type: 4665)
			arg_mc = ClientAddress.create(address_id: @arg_m.id,client_id: @arg_client.id)

			# create residence address
			@arg_r = FactoryGirl.create(:address,address_type: 4664)
			arg_rc = ClientAddress.create(address_id: @arg_r.id,client_id: @arg_client.id)
	 	end

	 	context "valid attributes" do 
	 		it "Updates the Model successfully with valid attributes" do 
	 			# changed mailing address city to "Conway" from Little Rock
				# Left side
				mailing_id = @arg_m.id
				
				change_address = 	{
										"#{mailing_id}" =>
											 { "city"=>"Conway"
											 }
								    }
				# Right side
				put :update, addresses:change_address
				# get the record from database.
				
				im_record = Address.find(mailing_id)
				# # test
				# right side == left side
				im_record.city.should == "Conway"
	 		end
	 	end

	 	context "invalid attributes" do 
	 		it "does not update address object when invalid attributes are passed." do 
	 			# changed date_administered from 2001-03-01 to 0001-04-01
	 			#  so after unsuccessful update - data should be still 2001-03-01
				# Left side
				mailing_id = @arg_m.id
				
				change_address = 	{
										"#{mailing_id}" =>
											 {"city"=>""
											  
											 }
								        }
				# Right side
				put :update, addresses:change_address
				# get the record from database.
				
				im_record = Address.find(mailing_id)
				# # test
				# right side == left side
				# from database before update is 2001-03-01 
				im_record.city.should == "Little Rock"
	 		end


	 	end

	end





	def fake_login
		 @user = FactoryGirl.create(:user)
	     @user_session = FactoryGirl.create(:user_session)
	     #To set created_by and updated_by fields.
	     AuditModule.set_current_user=(@user)
	end


end
