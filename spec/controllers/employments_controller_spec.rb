require 'rails_helper'
require 'spec_helper'

# rspec spec/controllers/employments_controller_spec.rb -fd
RSpec.describe EmploymentsController, :type => :controller do
	# Manoj Patil 08/11/2014.
	# For AUthlogic authentication 
	setup :activate_authlogic

	# 1.
	describe "GET #index" do 
		it "assigns the employment data for selected client to @employment" do
			# Fake Login
	 		fake_login()
	 		# proceed with actual testing
	 		# Create data - Left side of comparison
	 		arg_client = FactoryGirl.create(:client)
			arg_p = FactoryGirl.create(:employment,client: arg_client)
			# expected value - Right side of comparison -hitting the controller code.
	 		session[:CLIENT_ID] = arg_client.id
	 		get :index
		 	# Test
		 	assigns(:employment).last.employer_name.should == arg_p.employer_name

		end
		
	end 

	# 2.
	describe "GET #new" do 
		it "assigns a new employment object for selected client to @employment" do
			# Fake Login
	 		fake_login()
	 		# Left side
	 		arg_client = FactoryGirl.create(:client)
	 		arg_p = FactoryGirl.build(:employment,client: arg_client)

	 		# Right side
	 		session[:CLIENT_ID] = arg_client.id
	 		get :new
	 		# Test
	 		assigns(:employment).client_id.should == arg_client.id
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
			it "saves the new employment object in the database" do
				
	 			# Test
				expect{ post :create, employment: FactoryGirl.attributes_for(:employment,client: @arg_client) 
					  }.to change(Employment,:count).by(1) 

			end
			#4.
			it "redirects to the show page after successful creation." do
				post :create, employment: FactoryGirl.attributes_for(:employment,client: @arg_client) 
				response.should redirect_to Employment.last 

			end
		end 

		context "with invalid attributes" do 
			#5.
			it "does not save the new employment object in the database" do
				
				expect{ post :create, employment: FactoryGirl.attributes_for(:invalid_employment_data,client: @arg_client) 
				      }.to_not change(Employment,:count) 
			end
			#6.
			it "re-renders the :new template when creation is failed." do
				
				post :create, employment: FactoryGirl.attributes_for(:invalid_employment_data,client: @arg_client) 
				response.should render_template :new 
			end
		end 
	end	

	describe 'PUT update' do
		before :each do 
			# Fake Login
	 		fake_login()
	 		# left side - set up data
			@arg_client = FactoryGirl.create(:client, first_name: "Lawrence", last_name: "Smith") 
			@arg_employment = FactoryGirl.create(:employment,client: @arg_client,employer_name:"DELL")
			# Right side - controller needs session[:CLIENT_ID] needs to be populated.
			session[:CLIENT_ID] = @arg_client.id
		end 

		context "valid attributes" do 
			#7.
			it "located the requested @employment" do 
				# Right side
				put :update, id: @arg_employment,employment: FactoryGirl.attributes_for(:employment,client: @arg_client) 
				

				#Test
				assigns(:employment).should == @arg_employment
			end 
			#8.
			it "updates employment object when valid attributes are passed." do 
				# session[:CLIENT_ID] = @client.id
				# To the update action - attributes are passed (simulating attributes submitted by params)
				# changed employer_name:"HP"
				put :update, id: @arg_employment,employment: FactoryGirl.attributes_for(:employment, client: @arg_client, employer_name:"HP") 
				# reload the variables - they should reflect the modified data.
				@arg_employment.reload 
				# test
				@arg_employment.employer_name.should == "HP"
		    end 
		    #9.
		    it "redirects to the show page after successful update" do 
		    	
		    	put :update, id: @arg_employment.id,employment: FactoryGirl.attributes_for(:employment,client: @arg_client) 
		    	response.should redirect_to @arg_employment
		    end 
		end 

		context "invalid attributes" do 
			#10.
			it "locates the requested @employment" do 
				put :update,id: @arg_employment.id, employment: FactoryGirl.attributes_for(:invalid_employment_data,client: @arg_client) 
				assigns(:employment).should == @arg_employment 
			end 
			#11.
			it "does not update employment object when invalid attributes are passed." do 
				put :update, id: @arg_employment.id, employment: FactoryGirl.attributes_for(:employment, client: @arg_client,employer_name: nil) 
				
				@arg_employment.reload 
				@arg_employment.employer_name.should == "DELL"
			end 
			#12.
			it "re-renders the edit method when update is failed." do 
				put :update, id: @arg_employment.id, employment: FactoryGirl.attributes_for(:invalid_employment_data,client: @arg_client) 
				response.should render_template :edit 
			end 
		end 




	end	

	



	def fake_login
		 @user = FactoryGirl.create(:user)
	     @user_session = FactoryGirl.create(:user_session)
	end

end
