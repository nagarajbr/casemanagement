require 'rails_helper'
require 'spec_helper'

 # rspec spec/controllers/employment_details_controller_spec.rb -fd
RSpec.describe EmploymentDetailsController, :type => :controller do
	# Manoj Patil 08/11/2014.
	# For AUthlogic authentication 
	setup :activate_authlogic

	# 1.
	describe "GET #index" do 
		it "assigns the employment_detail data for selected Employment master to @employment_detail" do
			# Fake Login
	 		fake_login()
	 		# proceed with actual testing
	 		# Create data - Left side of comparison
	 		arg_client = FactoryGirl.create(:client)
			arg_employment_master = FactoryGirl.create(:employment,client: arg_client)
			arg_employment_detail = FactoryGirl.create(:employment_detail,employment_id:arg_employment_master.id)
			# expected value - Right side of comparison -hitting the controller code.
	 		session[:CLIENT_ID] = arg_client.id
	 		get :index,employment_id: arg_employment_master.id
		 	# Test ( left = right)
		 	assigns(:employment_details).last.salary_pay_amt.should == arg_employment_detail.salary_pay_amt

		end
		
	end 

	#2.
	describe "GET #new" do 
		it "assigns a new employment object for selected client to @employment" do
			# Fake Login
	 		fake_login()
	 		# Left side
	 		arg_client = FactoryGirl.create(:client)
	 		arg_employment_master = FactoryGirl.create(:employment,client: arg_client)
	 		arg_employment_detail = FactoryGirl.build(:employment_detail,employment_id:arg_employment_master.id)
	 		

	 		# Right side
	 		session[:CLIENT_ID] = arg_client.id
	 		get :new,employment_id:arg_employment_master.id
	 		# Test (left side == right side)
	 		assigns(:employment_detail).employment_id.should == arg_employment_detail.employment_id
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
	 		 @arg_employment_master = FactoryGirl.create(:employment,client: @arg_client)
		end

		context "with valid attributes" do 
			#3.
			it "saves the new employment_detail object in the database" do
				
	 			# Test
	 			# calling create method with params similation.
	 			# route path= /employments/:employment_id/employment_details
	 			# post <controller action>,<master_id: <>>,params[{employment_detail},{employment_id}]
				expect{ post :create, employment_id:@arg_employment_master.id, employment_detail: FactoryGirl.attributes_for(:employment_detail) 
					  }.to change(EmploymentDetail,:count).by(1) 

			end
			#4.
			it "redirects to the show page after successful creation." do
				post :create, employment_id:@arg_employment_master.id, employment_detail: FactoryGirl.attributes_for(:employment_detail) 
				# response.should redirect_to EmploymentDetail.last 
				response.should redirect_to employment_employment_detail_path(@arg_employment_master,EmploymentDetail.last)

			end
		end 

		context "with invalid attributes" do 
			#5.
			it "does not save the new employment detail object in the database" do
				
				expect{ post :create, employment_id:@arg_employment_master.id, employment_detail: FactoryGirl.attributes_for(:invalid_employment_detail_data) 
				      }.to_not change(EmploymentDetail,:count) 
			end
			#6.
			it "re-renders the :new template when creation is failed." do
				 post :create, employment_id:@arg_employment_master.id, employment_detail: FactoryGirl.attributes_for(:invalid_employment_detail_data) 
				 response.should render_template :new 
			end
		end 
	end	


	describe 'PUT update' do
		before :each do 
			# Fake Login
	 		 fake_login()
	 		 # left side - set up client test data
	 		 @arg_client = FactoryGirl.create(:client)
	 		 @arg_employment_master = FactoryGirl.create(:employment,client: @arg_client)
	 		 @arg_employment_detail = FactoryGirl.create(:employment_detail,employment_id:@arg_employment_master.id,salary_pay_amt:5000.00)
			
			 # right side controller needs session[:CLIENT_ID]
	 		 session[:CLIENT_ID] = @arg_client.id
		end 

		context "valid attributes" do 
			#7.
			it "located the requested @employment_detail" do 
				# Right side ( simulating employment_id and Id and params[:employment_detail])
				# put <controller action>,<master_id: <>>,params[{employment_detail},{employment_id}]
				put :update, employment_id:@arg_employment_master.id, id:  @arg_employment_detail.id,employment_detail: FactoryGirl.attributes_for(:employment_detail) 
				

				#Test ( update method first retrieves the correct record based on passed id)
				assigns(:employment_detail).should == @arg_employment_detail
			end 
			#8.
			it "updates employment_detail object when valid attributes are passed." do 
				# session[:CLIENT_ID] = @client.id
				# To the update action - attributes are passed (simulating attributes submitted by params)
				# changed salary:6000.00

				put :update, employment_id:@arg_employment_master.id, id:@arg_employment_detail.id,employment_detail: FactoryGirl.attributes_for(:employment_detail, salary_pay_amt:6000.00) 
				# reload the variables - they should reflect the modified data.
				 @arg_employment_detail.reload 
				# test
				 @arg_employment_detail.salary_pay_amt.should == 6000.00
		    end 
		    #9.
		    it "redirects to the show page after successful update" do 
		    	
		    	put :update, employment_id:@arg_employment_master.id, id:@arg_employment_detail.id,employment_detail: FactoryGirl.attributes_for(:employment_detail, salary_pay_amt:6000.00) 
		    	response.should redirect_to employment_employment_detail_path(@arg_employment_master,@arg_employment_detail)
		    end 
		end 

		context "invalid attributes" do 
			#10.
			it "locates the requested @employment_detail" do 
				put :update, employment_id:@arg_employment_master.id, id:  @arg_employment_detail.id,employment_detail: FactoryGirl.attributes_for(:invalid_employment_detail_data) 
				assigns(:employment_detail).should == @arg_employment_detail 
			end 
			#11.
			it "does not update employment object when invalid attributes are passed." do 
				put :update, employment_id:@arg_employment_master.id, id:  @arg_employment_detail.id,employment_detail: FactoryGirl.attributes_for(:invalid_employment_detail_data) 
				# put :update, id: @arg_employment.id, employment: FactoryGirl.attributes_for(:employment, client: @arg_client,employer_name: nil) 
				
				@arg_employment_detail.reload 
				@arg_employment_detail.salary_pay_amt.should == 5000.00
			end 
			#12.
			it "re-renders the edit method when update is failed." do 
				put :update, employment_id:@arg_employment_master.id, id:  @arg_employment_detail.id,employment_detail: FactoryGirl.attributes_for(:invalid_employment_detail_data) 
				response.should render_template :edit 
			end 
		end 




	end	



	def fake_login
		 @user = FactoryGirl.create(:user)
	     @user_session = FactoryGirl.create(:user_session)
	end


end
