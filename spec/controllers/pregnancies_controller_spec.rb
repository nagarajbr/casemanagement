require 'rails_helper'
require 'spec_helper'

# rspec spec/controllers/pregnancies_controller_spec.rb -fd
RSpec.describe PregnanciesController, :type => :controller do
	# Manoj Patil 08/05/2014.
	# For AUthlogic authentication 
	setup :activate_authlogic

		
	describe "GET #show" do 
		it "assigns the pregnancy data for selected client to @pregnancy" do
			# Fake Login
	 		fake_login()
	 		# proceed with actual testing
	 		# Create data - Left side of comparison
	 		arg_client = FactoryGirl.create(:client,gender:4478)
			arg_p = FactoryGirl.create(:pregnancy,client: arg_client)
			# expected value - Right side of comparison -hitting the controller code.
	 		session[:CLIENT_ID] = arg_client.id
		 	get :show 
		 	# Test
		 	assigns(:pregnancy).should == arg_p

		end
		
	end 

	describe "GET #new" do 
		it "assigns a new pregnancy object for selected client to @pregnancy" do
			# Fake Login
	 		fake_login()
	 		# Left side
	 		arg_client = FactoryGirl.create(:client,gender:4478)
	 		arg_p = FactoryGirl.build(:pregnancy,client: arg_client)

	 		# Right side
	 		session[:CLIENT_ID] = arg_client.id
	 		get :new
	 		# Test
	 		assigns(:pregnancy).pregnancy_status.should == "Y"
		end
	end 

	describe "POST #create" do 
		before :each do 
			# Fake Login
	 		 fake_login()
	 		 # left side - set up client test data
	 		 @arg_client = FactoryGirl.create(:client,gender:4478)
	 		 # right side controller needs session[:CLIENT_ID]
	 		 session[:CLIENT_ID] = @arg_client.id

		end

		context "with valid attributes" do 
			it "saves the new pregnancy object in the database" do
				
	 			# Test
				expect{ post :create, pregnancy: FactoryGirl.attributes_for(:pregnancy,client: @arg_client) 
					  }.to change(Pregnancy,:count).by(1) 

			end
			it "redirects to the show page" do
				post :create, pregnancy: FactoryGirl.attributes_for(:pregnancy,client: @arg_client) 
				response.should redirect_to show_pregnancy_url 

			end
		end 

		context "with invalid attributes" do 
			it "does not save the new pregnancy object in the database" do
				
				expect{ post :create, pregnancy: FactoryGirl.attributes_for(:invalid_pregnancy_data,client: @arg_client) 
				      }.to_not change(Pregnancy,:count) 
			end
			it "re-renders the :new template" do
				
				post :create, pregnancy: FactoryGirl.attributes_for(:invalid_pregnancy_data,client: @arg_client) 
				response.should render_template :new 
			end
		end 
	end	

	describe 'PUT update' do
		before :each do 
			# Fake Login
	 		fake_login()
	 		# left side - set up data
			@arg_client = FactoryGirl.create(:client, first_name: "Lawrence", last_name: "Smith",gender:4478) 
			@arg_pregnancy = FactoryGirl.create(:pregnancy,client: @arg_client,pregnancy_due_date:"2014-08-01",number_of_unborn: 1)
			# Right side - controller needs session[:CLIENT_ID] needs to be populated.
			session[:CLIENT_ID] = @arg_client.id
		end 

		context "valid attributes" do 
			it "located the requested @pregnancy" do 
				# Right side
				put :update, pregnancy: FactoryGirl.attributes_for(:pregnancy,client: @arg_client) 
				#Test
				assigns(:pregnancy).should == @arg_pregnancy
			end 

			it "changes @pregnancy's attributes" do 
				# session[:CLIENT_ID] = @client.id
				# To the update action - attributes are passed (simulating attributes submitted by params)
				# changed number_of_unborn to 2.
				put :update, pregnancy: FactoryGirl.attributes_for(:pregnancy, client: @arg_client, number_of_unborn: 2) 
				# reload the variables - they should reflect the modified data.
				@arg_pregnancy.reload 
				# test
				@arg_pregnancy.number_of_unborn.should == 2
		    end 

		    it "redirects to the show page" do 
		    	
		    	put :update, pregnancy: FactoryGirl.attributes_for(:pregnancy,client: @arg_client) 
		    	response.should redirect_to show_pregnancy_url
		    end 
		end 

		context "invalid attributes" do 
			it "locates the requested @pregnancy" do 
				put :update, pregnancy: FactoryGirl.attributes_for(:invalid_pregnancy_data,client: @arg_client) 
				assigns(:pregnancy).should == @arg_pregnancy 
			end 

			it "does not change @pregnancy's attributes" do 
				put :update, pregnancy: FactoryGirl.attributes_for(:pregnancy, client: @arg_client,number_of_unborn: nil) 
				
				@arg_pregnancy.reload 
				@arg_pregnancy.number_of_unborn.should == 1
			end 

			it "re-renders the edit method" do 
				put :update, pregnancy: FactoryGirl.attributes_for(:invalid_pregnancy_data,client: @arg_client) 
				response.should render_template :edit 
			end 
		end 


	end	


		
	def fake_login
		 @user = FactoryGirl.create(:user)
	     @user_session = FactoryGirl.create(:user_session)
	end	

end




  
