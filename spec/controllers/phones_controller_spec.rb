require 'rails_helper'
require 'spec_helper'

# rspec spec/controllers/phones_controller_spec.rb -fd
RSpec.describe PhonesController, :type => :controller do
	# Manoj Patil 08/05/2014.
	# For AUthlogic authentication 
	setup :activate_authlogic

	#1.
	describe "GET #show" do 
		it "assigns the phone numbers for selected client to @phones" do
			# Fake Login
	 		fake_login()
	 		# proceed with actual testing
	 		# Create data - Left side of comparison
	 		arg_client = FactoryGirl.create(:client)
			param_phones = 	[
								 {"number"=>"1111111111",
								 "client_id"=>arg_client.id,
								 "phone_type"=>"4661",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 },
								 {"number"=>"2222222222",
								 "client_id"=>arg_client.id,
								 "phone_type"=>"4663",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 },
								 {"number"=>"3333333333",
								 "extension"=>"44444",
								 "client_id"=>arg_client.id,
								 "phone_type"=>"4662",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 }
								 ]
			arg_phones = arg_client.phones.create( param_phones)					 
			# expected value - Right side of comparison -hitting the controller code.
	 		session[:CLIENT_ID] = arg_client.id
		 	get :show 
		 	# Test
		 	# right side == left side
		 	 assigns(:phones).first.number.should == "1111111111"
		 
		end
		
	end

	#2.
	describe "GET #new" do 
		it "assigns 3 new Phone objects for selected client to @phones" do
			# Fake Login
	 		fake_login()
	 		# Left side
	 		arg_client = FactoryGirl.create(:client)
	 		arg_home_phone = FactoryGirl.build(:phone,client: arg_client,phone_type: 4661)
	 		arg_mobile_phone = FactoryGirl.build(:phone,client: arg_client,phone_type:4663)
	 		arg_work_phone = FactoryGirl.build(:phone,client: arg_client,phone_type:4662)

	 		# Right side
	 		session[:CLIENT_ID] = arg_client.id
	 		get :new
	 		# Test
	 		arg_phones = assigns(:phones)
	 		li = 1
	 		arg_phones.each do |p|
	 			case li
	 				when li == 1 
	 					p.phone_type.should == arg_home_phone.phone_type
	 				when li == 2 
	 					p.phone_type.should == arg_mobile_phone.phone_type
	 				when li == 3 
	 					p.phone_type.should == arg_work_phone.phone_type
	 			end
	 			li = li + 1	
	 		end
	 		
		end
	end 

	#3.
	describe "POST #create" do 
		before :each do 
			# Fake Login
	 		 fake_login()
	 		 # left side - set up client test data
	 		 @arg_client = FactoryGirl.create(:client)
	 		 # right side controller needs session[:CLIENT_ID]
	 		 session[:CLIENT_ID] = @arg_client.id
	 		 @param_phones = 	[
								 {"number"=>"1111111111",
								 "client_id"=>@arg_client.id,
								 "phone_type"=>"4661",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 },
								 {"number"=>"2222222222",
								 "client_id"=>@arg_client.id,
								 "phone_type"=>"4663",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 },
								 {"number"=>"3333333333",
								 "extension"=>"44444",
								 "client_id"=>@arg_client.id,
								 "phone_type"=>"4662",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 }
								 ]
			 @param_home_phones =[
								 {"number"=>"1111111111",
								 "client_id"=>@arg_client.id,
								 "phone_type"=>"4661",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 }
								 ]	
			@param_home_and_mobile_phones =[
								 {"number"=>"1111111111",
								 "client_id"=>@arg_client.id,
								 "phone_type"=>"4661",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 },
								 {"number"=>"2222222222",
								 "client_id"=>@arg_client.id,
								 "phone_type"=>"4663",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 }
								 ]	
			 @param_invalid_home_phones =[
								 {"number"=>"",
								 "client_id"=>@arg_client.id,
								 "phone_type"=>"4661",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 }
								 ]
			@param_invalid_phones =[
								 {"number"=>"",
								 "client_id"=>@arg_client.id,
								 "phone_type"=>"4661",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 },
								 {"number"=>"2222222222",
								 "client_id"=>@arg_client.id,
								 "phone_type"=>"4663",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 }
								 ]					 					 				 				 

		end

		context "with valid attributes" do 
			# 4.
			it "Creates the Home,work,mobile phone object in the database" do
				
	 			
				# call the controller create method and it should change the Model count by 3.
				# since 3 records will be inserted.				 
	 			expect{ post :create, phones: @param_phones}.to change(Phone,:count).by(3)  
	 			
			end
			# 5.
			it "redirects to the show page after successful creation." do
				post :create, phones: @param_phones
				response.should redirect_to show_phone_url 

			end
			# 6.
			it "Creates the only Home phone object in the database" do
				
	 			
				# call the controller create method and it should change the Model count by 3.
				# since 3 records will be inserted.				 
	 			expect{ post :create, phones: @param_home_phones}.to change(Phone,:count).by(1)  
	 			
			end
			# 7.
			it "Creates the Home and mobile phone object in the database" do
				
	 			
				# call the controller create method and it should change the Model count by 3.
				# since 3 records will be inserted.				 
	 			expect{ post :create, phones: @param_home_and_mobile_phones}.to change(Phone,:count).by(2)  
	 			
			end
		end 

		context "with invalid attributes" do 
			# 6. 
			it "does not save the new phone objects in the database when invalid attributes are passed." do
				
				expect{ post :create, phones: @param_invalid_home_phones
				      }.to_not change(Phone,:count) 
			end
			
		end 
	end	

	describe 'PUT update' do
		before :each do 
			# Fake Login
	 		fake_login()
	 		# left side - set up data
			@arg_client = FactoryGirl.create(:client, first_name: "John", last_name: "Smith") 
			@arg_client = Client.find_by(first_name: "John",last_name: "Smith")
			@param_update_phones ={
				             "190"=>
				                  {"number"=>"2222222222",
									 "client_id"=>"1",
									 "phone_type"=>"4661",
									 "created_by"=>"1",
									 "updated_by"=>"1"
							 	 },
								 "191"=>
								 {"number"=>"3333333333",
								 "client_id"=>"1",
								 "phone_type"=>"4663",
								 "created_by"=>"1",
								 "updated_by"=>"1"
								 },
								 "192"=>
								 {"number"=>"4444444444",
								 "extension"=>"55555",
								 "client_id"=>"1",
								 "phone_type"=>"4662",
								 "created_by"=>"1",
								 "updated_by"=>"1"
								}
							}
			@param_phones = 	[
								 {"number"=>"1111111111",
								 "client_id"=>@arg_client.id,
								 "phone_type"=>"4661",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 },
								 {"number"=>"2222222222",
								 "client_id"=>@arg_client.id,
								 "phone_type"=>"4663",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 },
								 {"number"=>"3333333333",
								 "extension"=>"44444",
								 "client_id"=>@arg_client.id,
								 "phone_type"=>"4662",
								 "created_by"=>"21",
								 "updated_by"=>"21"
								 }
								 ]
			@arg_phones = @arg_client.phones.create(@param_phones)
			# Right side - controller needs session[:CLIENT_ID] needs to be populated.
			session[:CLIENT_ID] = @arg_client.id
		end 

		context "valid attributes" do 
			

			it "Updates the Model successfully with valid attributes" do 
				
				# changed phone number to "9876543211" from "1111111111"
				# Left side
				phone_id = @arg_phones.first.id
				change_phones = 	{
										"#{phone_id}" =>
											 {"number"=>"9876543211",
											 "client_id"=>@arg_client.id,
											 "phone_type"=>"4661",
											 "created_by"=>"21",
											 "updated_by"=>"21"
											 }
								  }
				# Right side
				put :update, phones:change_phones
				# get the record from database.
				ph_record = Phone.find(phone_id)
				# # test
				# right side == left side
				ph_record.number.should == "9876543211"

		    end 

		 
		end 

		context "invalid attributes" do 
		

			it "does not update phone object when invalid attributes are passed." do 
				#  left side
				phone_id = @arg_phones.first.id
				# puts "phone_id = #{phone_id}"
				#  phone type = "" to make it invalid
				change_phones = 	{
										"#{phone_id}" =>
											 {"number"=>"565656",
											 "client_id"=>@arg_client.id,
											 "phone_type"=>"",
											 "created_by"=>"21",
											 "updated_by"=>"21"
											 }
								  }
				put :update, phones:change_phones
				# # reload the variables - they should reflect the modified data.
				#  right side. retrrive from database to verify still old phone number "1111111111" is retained.
				@arg_phones = @arg_client.phones
				ph_record = @arg_phones.first
				# puts "phone number = #{ph_record.number}"
				ph_record.number.should == "1111111111"
				

								  
			end 

	
		end 


	end	
	



	def fake_login
		 @user = FactoryGirl.create(:user)
	     @user_session = FactoryGirl.create(:user_session)
	end	
end
