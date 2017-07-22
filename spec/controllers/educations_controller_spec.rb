require 'rails_helper'

RSpec.describe EducationsController, :type => :controller do
	setup :activate_authlogic
	
	# 1.
	describe "GET #index" do 
		it "assigns the education data for selected client to @education" do
			# Fake Login
	 		fake_login()
	 		# proceed with actual testing
	 		# Create data - Left side of comparison
	 		arg_client = FactoryGirl.create(:client)
			arg_p = FactoryGirl.create(:education,client: arg_client)
			# expected value - Right side of comparison -hitting the controller code.
	 		session[:CLIENT_ID] = arg_client.id
	 		get :index
		 	# Test
		 	assigns(:educations).last.school_type.should == arg_p.school_type
		end
	end

	# 2.
	describe "GET #new" do 
		it "assigns a new education object for selected client to @education" do
			# Fake Login
	 		fake_login()
	 		# Left side
	 		arg_client = FactoryGirl.create(:client)
	 		arg_p = FactoryGirl.build(:education,client: arg_client)

	 		# Right side
	 		session[:CLIENT_ID] = arg_client.id
	 		get :new
	 		# Test
	 		assigns(:education).client_id.should == arg_client.id
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
			it "saves the new education object in the database" do
	 			# Test
				expect{ post :create, education: FactoryGirl.attributes_for(:education,client: @arg_client) 
					  }.to change(Education,:count).by(1) 
			end
			#4.
			it "redirects to the show page after successful creation." do
				post :create, education: FactoryGirl.attributes_for(:education,client: @arg_client) 
				response.should redirect_to educations_path 
			end
		end 

		context "with invalid attributes" do 
			#5.
			it "does not save the new education object in the database" do
				expect{ post :create, education: FactoryGirl.attributes_for(:invalid_education,client: @arg_client) 
				      }.to_not change(Education,:count) 
			end
			#6.
			it "re-renders the :new template when creation is failed." do
				post :create, education: FactoryGirl.attributes_for(:invalid_education,client: @arg_client) 
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
			@arg_education = FactoryGirl.create(:education,client: @arg_client,high_grade_level:"10")
			# Right side - controller needs session[:CLIENT_ID] needs to be populated.
			session[:CLIENT_ID] = @arg_client.id
		end 

		context "valid attributes" do 
			#7.
			it "located the requested @education" do 
				# Right side
				put :update, id: @arg_education,education: FactoryGirl.attributes_for(:education,client: @arg_client) 
				

				#Test
				assigns(:education).should == @arg_education
			end 
			#8.
			it "updates education object when valid attributes are passed." do 
				# session[:CLIENT_ID] = @client.id
				# To the update action - attributes are passed (simulating attributes submitted by params)
				# changed high_grade_level:"11"
				put :update, id: @arg_education,education: FactoryGirl.attributes_for(:education, client: @arg_client, high_grade_level:"11") 
				# reload the variables - they should reflect the modified data.
				@arg_education.reload 
				# test
				@arg_education.high_grade_level.should == 11
		    end 
		    #9.
		    it "redirects to the show page after successful update" do 
		    	
		    	put :update, id: @arg_education.id,education: FactoryGirl.attributes_for(:education,client: @arg_client) 
		    	response.should redirect_to @arg_education
		    end 
		end 

		context "invalid attributes" do 
			#10.
			it "locates the requested @education" do 
				put :update,id: @arg_education.id, education: FactoryGirl.attributes_for(:invalid_education,client: @arg_client) 
				assigns(:education).should == @arg_education 
			end 
			#11.
			it "does not update education object when invalid attributes are passed." do 
				put :update, id: @arg_education.id, education: FactoryGirl.attributes_for(:education, client: @arg_client,high_grade_level: nil) 
				
				@arg_education.reload 
				@arg_education.high_grade_level.should == 10
			end 
			#12.
			it "re-renders the edit method when update is failed." do 
				put :update, id: @arg_education.id, education: FactoryGirl.attributes_for(:invalid_education,client: @arg_client) 
				response.should render_template :edit 
			end 
		end 
	end

	def fake_login
		@user = FactoryGirl.create(:user)
	    @user_session = FactoryGirl.create(:user_session)
	end	
end
