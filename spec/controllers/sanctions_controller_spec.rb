require 'rails_helper'
require 'spec_helper'

# rspec spec/controllers/sanctions_controller_spec.rb -fd
RSpec.describe SanctionsController, :type => :controller do
	# Manoj Patil 08/11/2014.
	# For AUthlogic authentication 
	setup :activate_authlogic

	# 1.
	describe "GET #index" do 
		it "assigns the Sanction data for selected client to @sanction" do
			# Fake Login
	 		fake_login()
	 		# proceed with actual testing
	 		# Create data - Left side of comparison
	 		arg_client = FactoryGirl.create(:client)
			arg_p = FactoryGirl.create(:sanction,client: arg_client)
			# expected value - Right side of comparison -hitting the controller code.
	 		session[:CLIENT_ID] = arg_client.id
	 		get :index
		 	# Test
		 	assigns(:sanctions).last.service_program_id.should == arg_p.service_program_id

		end
		
	end 

	# 2.
	describe "GET #new" do 
		it "assigns a new sanction object for selected client to @sanction" do
			# Fake Login
	 		fake_login()
	 		# Left side
	 		arg_client = FactoryGirl.create(:client)
	 		arg_p = FactoryGirl.build(:sanction,client: arg_client)

	 		# Right side
	 		session[:CLIENT_ID] = arg_client.id
	 		get :new
	 		# Test
	 		assigns(:sanction).client_id.should == arg_client.id
		end
	end 

	
	describe "POST #create" do 
		before :each do 
			# Fake Login
	 		 fake_login()
	 		 # left side - set up client test data
	 		 @arg_client = FactoryGirl.create(:client)
	 		 # right side controller needs session[:CLIENT_ID]
	 		 session[:CLIENT_ID] = @arg_client.id

		end

		context "with valid attributes" do 
			#3.
			it "saves the new sanction object in the database" do
				
	 			# Test
				expect{ post :create, sanction: FactoryGirl.attributes_for(:sanction,client: @arg_client) 
					  }.to change(Sanction,:count).by(1) 

			end
			#4.
			it "redirects to the show page after successful creation." do
				post :create, sanction: FactoryGirl.attributes_for(:sanction,client: @arg_client) 
				response.should redirect_to Sanction.last 

			end
		end 

		context "with invalid attributes" do 
			#5.
			it "does not save the new employment object in the database" do
				
				expect{ post :create, sanction: FactoryGirl.attributes_for(:invalid_sanction_data,client: @arg_client) 
				      }.to_not change(Sanction,:count) 
			end
			#6.
			it "re-renders the :new template when creation is failed." do
				
				post :create, sanction: FactoryGirl.attributes_for(:invalid_sanction_data,client: @arg_client) 
				response.should render_template :new 
			end
		end 
	end	

	describe 'PUT update' do
		before :each do 
			# Fake Login
	 		fake_login()
	 		# left side - set up data
			@arg_client = FactoryGirl.create(:client) 
			#  set duration to 1 week and change to 1 month later.
			#  duration = 1 week(21)
			#  duration = 1 month (23)
			@arg_sanction = FactoryGirl.create(:sanction,client: @arg_client,duration_type: 21)
			# Right side - controller needs session[:CLIENT_ID] needs to be populated.
			session[:CLIENT_ID] = @arg_client.id
		end 

		context "valid attributes" do 
			#7.
			it "located the requested @sanction" do 
				# Right side
				put :update, id: @arg_sanction,sanction: FactoryGirl.attributes_for(:sanction,client: @arg_client) 
				

				#Test
				assigns(:sanction).should == @arg_sanction
			end 
			#8.
			it "updates sanction object when valid attributes are passed." do 
				# session[:CLIENT_ID] = @client.id
				# To the update action - attributes are passed (simulating attributes submitted by params)
				# changed duration to 1 month:23
				put :update, id: @arg_sanction,sanction: FactoryGirl.attributes_for(:sanction, client: @arg_client, duration_type: 23) 
				# reload the variables - they should reflect the modified data.
				@arg_sanction.reload 
				# test
				@arg_sanction.duration_type.should == 23
		    end 
		    #9.
		    it "redirects to the show page after successful update" do 
		    	
		    	put :update, id: @arg_sanction.id,sanction: FactoryGirl.attributes_for(:sanction,client: @arg_client) 
		    	response.should redirect_to @sanction
		    end 
		end 

		context "invalid attributes" do 
			#10.
			it "locates the requested @sanction" do 
				put :update,id: @arg_sanction.id, sanction: FactoryGirl.attributes_for(:invalid_sanction_data,client: @arg_client) 
				assigns(:sanction).should == @arg_sanction 
			end 
			#11.
			it "does not update sanction object when invalid attributes are passed." do 
				put :update, id: @arg_sanction.id, sanction: FactoryGirl.attributes_for(:sanction, client: @arg_client, duration_type: nil) 
				
				@arg_sanction.reload 
				@arg_sanction.duration_type.should == 21
			end 
			#12.
			it "re-renders the edit method when update is failed." do 
				put :update, id: @arg_sanction.id, sanction: FactoryGirl.attributes_for(:invalid_sanction_data,client: @arg_client) 
				response.should render_template :edit 
			end 
		end 


	end	



	def fake_login
		 @user = FactoryGirl.create(:user)
	     @user_session = FactoryGirl.create(:user_session)
	       #Capture login information into module and make sure it is available across all the models
	     #To set created_by and updated_by fields.
	     AuditModule.set_current_user=(@user)
	end

end

