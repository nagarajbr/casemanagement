require 'rails_helper'
require 'spec_helper'

RSpec.describe ExpensesController, :type => :controller do
	setup :activate_authlogic
	before :each do
		#This medthod should be called across every test scenario
		#before :each will avoid redundancy and provides DRY
    	fake_login()
    end

    describe "GET #index" do
		#index contoller method returns a list of expense records,
		# so create a list and compare the populated listed with the list returned by the controller
		# setting up data
		it "populates a list of expenses" do
			expense1 = FactoryGirl.create(:expense)
		    client_expense1 = FactoryGirl.create(:client_expense,client_id: @client.id,expense_id: expense1.id)
		    expense2 = FactoryGirl.create(:expense)
		    client_expense2 = FactoryGirl.create(:client_expense,client: @client, expense: expense2)
		    #Populate an empyty Expense::ActiveRecord_Associations_CollectionProxy, so that comparision can be done directly
		    expenses = @client.expenses
		    # Add the income records to the collection
		    expenses << expense1
		    expenses << expense2
		    #call the ExpensesController index method
		    get :index
		    #Check whether the collection populated and the collection returned by the controller are same
		    assigns(:expense).should eq(expenses)
		end
	end

	describe "GET #new" do
		#new method builds an empty expense object,build a new expense object and compare it with the object returned from the controller
		it "creates a new income object for selected client" do
			expense1 = @client.expenses.new
	 		get :new
	 		# Check whether new method just builds a new object for expense
	 		assigns(:expense) == expense1
		end
	end


	describe "POST #create" do
		context "with valid attributes" do
			#For all valid attributes as input the expenses table should increase its count by 1 on create
			it "saves the new expense object in the database" do
				expect{ post :create, expense: FactoryGirl.attributes_for(:expense)
					  }.to change(Expense,:count).by(1)
			end

			#For all valid attributes as input the expenses table and client_expenses should increase its count by 1 on create
			it "create a record in both expense and client_expenses table on income save" do
				expect{ post :create, expense: FactoryGirl.attributes_for(:expense)
					  }.to change(Expense,:count).by(1) and change(ClientExpense,:count).by(1)
			end

			#For all valid attributes as input the create should insert a record in the database
			#and populate the created_by and updated_by fields with the logged in user id
			it "creates a record with created_by and updated_by fields with logged in user id" do
				expect{ post :create, expense: FactoryGirl.attributes_for(:expense)
					  }.to change(Expense,:count).by(1) and Expense.last.created_by == @user.uid and Expense.last.updated_by == @user.uid
			end

			#For all valid attributes as input on sucessuful create it should redirect to the index page
			it "redirects to expense index page on successful creation." do
				post :create, expense: FactoryGirl.attributes_for(:expense)
				response.should redirect_to expenses_path
			end
		end

		context "with invalid attributes" do
			#For any invalid attributes as input the create should not do any insertion and the count on the table should remain same
			it "will not save the expense object in the database" do
				expect{ post :create, expense: FactoryGirl.attributes_for(:invalid_expense)
				      }.to_not change(Expense,:count)
			end

			#For any invalid attributes as input the create should fail and render the new page
			it "re-renders the :new template when create is fails." do
				post :create, expense: FactoryGirl.attributes_for(:invalid_expense)
				response.should render_template :new
			end
		end
	end

	describe 'PUT #update' do
		before :each do
			@expense = FactoryGirl.create(:expense)
    	end
		context "valid attributes" do
			#For update action first we need to check whether the right record is being updated
			it "located the requested @expense" do
				put :update, id: @expense, expense: FactoryGirl.attributes_for(:expense)
				assigns(:expense).should == @expense
			end

			#For valid attributes passed on update check whether the update is successful or not
			it "updates expense object when valid attributes are passed" do
				put :update, id: @expense, expense: FactoryGirl.attributes_for(:expense, expensetype: 2534)
				# reload the variables - they should reflect the modified data.
				@expense.reload
				# test
				@expense.expensetype.should == 2534
		    end

		    #For all valid attributes as input the update should update a record in the database
			#and populate the updated_by field with the logged in user id
			it "updates a record withupdated_by fields with logged in user id and created_by field remains unchanged" do
				 logged_in_user = FactoryGirl.create(:user,login: "update_user", name: "update_user", email_id: "update_user@email.com")
	     		 @user_session = FactoryGirl.create(:user_session, login: "update_user")
	             AuditModule.set_current_user=(logged_in_user)
	             put :update, id: @expense ,expense: FactoryGirl.attributes_for(:expense,expensetype: 2534)
	             assigns(:expense).updated_by.should == logged_in_user.id and assigns(:expense).created_by.should == @user.uid
			end

		   #For all valid attributes as input on sucessuful update it should redirect to the show page
		    it "redirects to the show page after successful update" do
		    	put :update, id: @expense ,expense: FactoryGirl.attributes_for(:expense,expensetype: 2534)
		    	response.should redirect_to @expense
		    end
		end

		context "invalid attributes" do
			#For update action first we need to check whether the right record is being updated
			it "locates the requested @expense" do
				put :update,id: @expense, expense: FactoryGirl.attributes_for(:invalid_expense)
				assigns(:expense).should == @expense
			end

			#For all invalid attributes as input the update should fail and the object should persist it's previous data
			it "does not update expense object when invalid attributes are passed." do
				put :update,id: @expense, expense: FactoryGirl.attributes_for(:invalid_expense)
				@expense.reload
				@expense.expensetype.should ==  2533
			end

			#For all invalid attributes as input the update should fail and render back to the update screen
			it "re-renders the edit method when update is failed." do
				put :update,id: @expense, expense: FactoryGirl.attributes_for(:invalid_expense)
				response.should render_template :edit
			end
		end
	end



	describe "DELETE #destroy" do
		before :each do
			@expense = FactoryGirl.create(:expense)
    	end

	    it "destroys the requested expense record" do
	      expect {
	        delete :destroy, id: @expense
	      }.to change(Expense, :count).by(-1)
	    end

	    it "destroys the requested expense record and client_expenses record as well" do
	      expect {
	        delete :destroy, id: @expense
	      }.to change(Expense, :count).by(-1) and change(ClientExpense, :count).by(-1)
	    end

	    it "redirects to the expenses index on successful delete" do
	      delete :destroy, id: @expense
	      response.should redirect_to expenses_path
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
