require 'rails_helper'

RSpec.describe ExpenseDetailsController, :type => :controller do
	setup :activate_authlogic

	before :each do
		fake_login()
    	create_expense()
    end

     def fake_login
		 @user = FactoryGirl.create(:user)
	     @user_session = FactoryGirl.create(:user_session)
	     AuditModule.set_current_user=(@user)
	     @client = FactoryGirl.create(:client)
		 session[:CLIENT_ID] = @client.id
	end

	def create_expense
		@expense = FactoryGirl.create(:expense)
		create_expense_detail()
	end

	def create_expense_detail
		@expense_detail = FactoryGirl.create(:expense_detail, expense_id: @expense.id)
	end

	describe "GET #index" do
		it "populates a list of expense_details" do
			expenses = @client.expenses
			expenses << @expense
		    expense_detail1 = FactoryGirl.create(:expense_detail, expense_id: @expense.id)
		    expense_detail2 = FactoryGirl.create(:expense_detail, expense_id: @expense.id, expense_amount: "100.00")
		    expense_details = @expense.expense_details
		    get :index, expense_id: @expense.id
		    assigns(:expensedetails).should eq(expense_details)
		end
	end

	describe "GET #new" do
		it "creates a new expense_details object against the given expense object" do
			expense1 = @client.expenses.new
	 		get :new,expense_id: @expense.id
	 		assigns(:expense) == expense1
		end
	end

	describe "POST #create" do
		context "with valid attributes" do

			it "saves the new expense_detail object in the database" do
				expect{ post :create,expense_id: @expense.id, expense_detail: FactoryGirl.attributes_for(:expense_detail)
					  }.to change(ExpenseDetail,:count).by(1)
			end

			it "creates a record in expense_details with created_by and updated_by fields with logged in user id" do
				expect{ post :create, expense_id: @expense.id, expense_detail: FactoryGirl.attributes_for(:expense_detail)
					  }.to change(ExpenseDetail,:count).by(1) and Expense.last.created_by == @user.uid and Expense.last.updated_by == @user.uid
			end

			it "redirects to expense_details index page on successful creation." do
				post :create, expense_id: @expense.id, expense_detail: FactoryGirl.attributes_for(:expense_detail)
				response.should redirect_to expense_expense_details_path(@expense)
			end
		end

		context "with invalid attributes" do

			it "will not save the expense_detail object in the database" do
				expect{ post :create, expense_id: @expense.id, expense_detail: FactoryGirl.attributes_for(:invalid_expense_detail)
				      }.to_not change(ExpenseDetail,:count)
			end

			it "re-renders the :new template when create is fails." do
				post :create, expense_id: @expense.id, expense_detail: FactoryGirl.attributes_for(:invalid_expense_detail)
				response.should render_template :new
			end
		end
	end

	describe 'PUT #update' do
		context "valid attributes" do

			it "located the requested expense_detail" do
				put :update, expense_id: @expense.id, id: @expense_detail, expense_detail: FactoryGirl.attributes_for(:expense_detail)
				assigns(:expensedetails).should == @expense_detail
			end


		    it "updates a record with updated_by fields with logged in user id" do
				 logged_in_user = FactoryGirl.create(:user,login: "update_user", name: "update_user", email_id: "update_user@email.com")
	     		 @user_session = FactoryGirl.create(:user_session, login: "update_user")
	             AuditModule.set_current_user=(logged_in_user)
	             put :update, expense_id: @expense.id, id: @expense_detail, expense_detail: FactoryGirl.attributes_for(:expense_detail, expense_amount: "20.00")
	             assigns(:expensedetails).updated_by.should == logged_in_user.id
			end

			it "updates a record but the created_by field remains unchanged" do
				 logged_in_user = FactoryGirl.create(:user,login: "update_user", name: "update_user", email_id: "update_user@email.com")
	     		 @user_session = FactoryGirl.create(:user_session, login: "update_user")
	             AuditModule.set_current_user=(logged_in_user)
	             put :update, expense_id: @expense.id, id: @expense_detail, expense_detail: FactoryGirl.attributes_for(:expense_detail, expense_amount: "20.00")
	             assigns(:expensedetails).created_by.should == @user.uid
			end

		end

		context "invalid attributes" do
			it "locates the requested @expense_detail" do
				put :update, expense_id: @expense.id, id: @expense_detail, expense_detail: FactoryGirl.attributes_for(:invalid_expense_detail)
				assigns(:expensedetails).should == @expense_detail
			end

			it "re-renders the edit method when update is failed." do
				put :update, expense_id: @expense.id, id: @expense_detail, expense_detail: FactoryGirl.attributes_for(:invalid_expense_detail)
				response.should render_template :edit
			end
		end
	end

	describe "DELETE #destroy" do
		it "destroys the requested expense record" do
	      expect {
	        delete :destroy, expense_id: @expense.id, id: @expense_detail
	      }.to change(ExpenseDetail, :count).by(-1)
	    end

	    it "redirects to the expense_details index on successful delete" do
	      delete :destroy, expense_id: @expense.id, id: @expense_detail
	      response.should redirect_to expense_expense_details_path(@expense)
	    end
	end

end
