require 'rails_helper'
require 'spec_helper'

RSpec.describe IncomesController, :type => :controller do
	setup :activate_authlogic

	before :each do
		#This medthod should be called across every test scenario
		#before :each will avoid redundancy and provides DRY
    	fake_login()
    end

	describe "GET #index" do
		#index contoller method returns a list of income records,
		# so create a list and compare the populated listed with the list returned by the controller
		# setting up data
		it "populates a list of incomes" do
			income1 = FactoryGirl.create(:income)
		    client_income1 = FactoryGirl.create(:client_income,client_id: @client.id,income_id: income1.id)
		    income2 = FactoryGirl.create(:income)
		    client_income2 = FactoryGirl.create(:client_income,client: @client, income: income2)
		    #Populate an empyty Income::ActiveRecord_Associations_CollectionProxy, so that comparision can be done directly
		    incomes = @client.incomes
		    # Add the income records to the collection
		    incomes << income1
		    incomes << income2
		    #call the IncomesController index method
		    get :index
		    #Check whether the collection populated and the collection returned by the controller are same
		    assigns(:incomes).should eq(incomes)
		end
	end

	describe "GET #new" do
		#new method builds an empty income object,build a new income object and compare it with the object returned from the controller
		it "creates a new income object for selected client" do
			income1 = @client.incomes.new
	 		get :new
	 		# Check whether new method just builds a new object for income
	 		assigns(:income) == income1
		end
	end

	describe "POST #create" do
		context "with valid attributes" do
			#For all valid attributes as input the incomes table should increase its count by 1 on create
			it "saves the new income object in the database" do
				expect{ post :create, income: FactoryGirl.attributes_for(:income)
					  }.to change(Income,:count).by(1)
			end

			#For all valid attributes as input the incomes table and client_incomes should increase its count by 1 on create
			it "create a record in both income and client_incomes table on income save" do
				expect{ post :create, income: FactoryGirl.attributes_for(:income)
					  }.to change(Income,:count).by(1) and change(ClientIncome,:count).by(1)
			end

			#For all valid attributes as input the create should insert a record in the database
			#and populate the created_by and updated_by fields with the logged in user id
			it "creates a record with created_by and updated_by fields with logged in user id" do
				expect{ post :create, income: FactoryGirl.attributes_for(:income)
					  }.to change(Income,:count).by(1) and Income.last.created_by == @user.uid and Income.last.updated_by == @user.uid
			end

			#For all valid attributes as input on sucessuful create it should redirect to the index page
			it "redirects to income index page on successful creation." do
				post :create, income: FactoryGirl.attributes_for(:income)
				response.should redirect_to incomes_path
			end
		end

		context "with invalid attributes" do
			#For any invalid attributes as input the create should not do any insertion and the count on the table should remain same
			it "will not save the income object in the database" do
				expect{ post :create, income: FactoryGirl.attributes_for(:invalid_income_data)
				      }.to_not change(Income,:count)
			end

			#For any invalid attributes as input the create should fail and render the new page
			it "re-renders the :new template when create is fails." do
				post :create, income: FactoryGirl.attributes_for(:invalid_income_data)
				response.should render_template :new
			end
		end
	end

	describe 'PUT #update' do
		before :each do
			@income = FactoryGirl.create(:income)
    	end
		context "valid attributes" do
			#For update action first we need to check whether the right record is being updated
			it "locate the income object to be updated" do
				put :update, id: @income, income: FactoryGirl.attributes_for(:income)
				assigns(:income).should == @income
			end

			#For valid attributes passed on update check whether the update is successful or not
			it "updates income object when valid attributes are passed" do
				put :update, id: @income, income: FactoryGirl.attributes_for(:income, contract_amt: 18.38)
				# reload the variables - they should reflect the modified data.
				@income.reload
				# test
				@income.contract_amt.should == 18.38
		    end

		    #For all valid attributes as input the update should update a record in the database
			#and populate the updated_by field with the logged in user id
			it "updates a record withupdated_by fields with logged in user id and created_by field remains unchanged" do
				 logged_in_user = FactoryGirl.create(:user,login: "update_user", name: "update_user", email_id: "update_user@email.com")
	     		 @user_session = FactoryGirl.create(:user_session, login: "update_user")
	             AuditModule.set_current_user=(logged_in_user)
	             put :update, id: @income ,income: FactoryGirl.attributes_for(:income,contract_amt: 18.04)
	             assigns(:income).updated_by.should == logged_in_user.id and assigns(:income).created_by.should == @user.uid
			end

		   #For all valid attributes as input on sucessuful update it should redirect to the show page
		    it "redirects to the show page after successful update" do
		    	put :update, id: @income ,income: FactoryGirl.attributes_for(:income,contract_amt: 138.38)
		    	response.should redirect_to @income
		    end
		end

		context "invalid attributes" do
			#For update action first we need to check whether the right record is being updated
			it "locates the requested @income" do
				put :update,id: @income, income: FactoryGirl.attributes_for(:invalid_income_data)
				assigns(:income).should == @income
			end

			#For all invalid attributes as input the update should fail and the object should persist it's previous data
			it "does not update income object when invalid attributes are passed." do
				put :update,id: @income, income: FactoryGirl.attributes_for(:invalid_income_data)
				@income.reload
				@income.incometype.should == 2658
			end

			#For all invalid attributes as input the update should fail and render back to the update screen
			it "re-renders the edit method when update is failed." do
				put :update,id: @income, income: FactoryGirl.attributes_for(:invalid_income_data)
				response.should render_template :edit
			end
		end
	end

	describe "DELETE #destroy" do
		before :each do
			@income = FactoryGirl.create(:income)
    	end

	    it "destroys the requested income record" do
	      expect {
	        delete :destroy, id: @income
	      }.to change(Income, :count).by(-1)
	    end

	    it "destroys the requested income record and client_incomes record as well" do
	      expect {
	        delete :destroy, id: @income
	      }.to change(Income, :count).by(-1) and change(ClientIncome, :count).by(-1)
	    end

	    it "redirects to the incomes index on successful delete" do
	      delete :destroy, id: @income
	      response.should redirect_to incomes_path
	    end
	end

	def fake_login
		 #simulating user login, login screen functionality
		 @user = FactoryGirl.create(:user)
	     @user_session = FactoryGirl.create(:user_session)
	     #Capture login information into module and make sure it is available across all the models
	     #To set created_by and updated_by fields.
	     AuditModule.set_current_user=(@user)
	     #setting the client in the session, search screen functionality
	     @client = FactoryGirl.create(:client)
		 session[:CLIENT_ID] = @client.id
	end
end