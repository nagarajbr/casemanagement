require 'rails_helper'
require 'spec_helper'

# rspec spec/controllers/clients_controller_spec.rb -fd
RSpec.describe ClientsController, :type => :controller do
	# Manoj Patil 08/05/2014.
	# For AUthlogic authentication 
	setup :activate_authlogic
	


	describe "GET #show" do 
		
	 	it "populates client instance variable" do 
	 		# Fake Login
	 		fake_login()
	 		
	      	# proceed with actual testing

		 		cl = FactoryGirl.create(:client) 
		 		session[:CLIENT_ID] = cl.id
		 		get :show 
		 		assigns(:client).should == cl
		 	# end
	 	end 
	end 

	describe "GET #new" do 
		it "assigns a new client object for selected client to @client" do
			# Fake Login
	 		fake_login()
	 		# Left side
	 		arg_client = Client.new
	 		# Right side
	 		get :new
	 		# Test
	 		assigns(:client) == arg_client
		end
	end 

	describe "POST #create" do 
		before :each do 
			# Fake Login
	 		 fake_login()
	 		 # left side - set up client test data
	 		 # @arg_client = FactoryGirl.create(:client,sex:4478)
	 		 # right side controller needs session[:CLIENT_ID]
	 		 # session[:CLIENT_ID] = @arg_client.id

		end

		context "with valid attributes" do 
			it "saves the new client object in the database" do
				
	 			# Test
				expect{ post :create, client: FactoryGirl.attributes_for(:client) 
					  }.to change(Client,:count).by(1) 

			end
			it "redirects to the show page" do
				post :create, client: FactoryGirl.attributes_for(:client) 
				response.should redirect_to show_client_path 

			end
		end 

		context "with invalid attributes" do 
			it "does not save the new client object in the database" do
				
				expect{ post :create, client: FactoryGirl.attributes_for(:invalid_client_data) 
				      }.to_not change(Client,:count) 
			end
			it "re-renders the :new template" do
				
				post :create, client: FactoryGirl.attributes_for(:invalid_client_data) 
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
			# Right side - controller needs session[:CLIENT_ID] needs to be populated.
			session[:CLIENT_ID] = @arg_client.id
		end 

		context "valid attributes" do 
			it "located the requested @client" do 
				# Right side
				put :update, client: FactoryGirl.attributes_for(:client) 
				#Test
				assigns(:client).should == @arg_client
			end 

			it "changes @client's attributes" do 
				# session[:CLIENT_ID] = @client.id
				# To the update action - attributes are passed (simulating attributes submitted by params)
				# changed last name to "Bond"
				put :update, client: FactoryGirl.attributes_for(:client,last_name: "Bond") 
				# reload the variables - they should reflect the modified data.
				@arg_client.reload 
				# test
				@arg_client.last_name.should == "Bond"
		    end 

		    it "redirects to the show page" do 
		    	
		    	put :update, client: FactoryGirl.attributes_for(:client) 
		    	response.should redirect_to show_client_path
		    end 
		end 

		context "invalid attributes" do 
			it "locates the requested @client" do 
				put :update, client: FactoryGirl.attributes_for(:invalid_client_data) 
				assigns(:client).should == @arg_client 
			end 

			it "does not change @client's attributes" do 
				put :update, client: FactoryGirl.attributes_for(:client,first_name: nil) 
				
				@arg_client.reload 
				@arg_client.first_name.should == "Lawrence"
			end 

			it "re-renders the edit method" do 
				put :update, client: FactoryGirl.attributes_for(:invalid_client_data) 
				response.should render_template :edit 
			end 
		end 


	end	




	def fake_login
		 @user = FactoryGirl.create(:user)
	     @user_session = FactoryGirl.create(:user_session)
	end	

end




  
