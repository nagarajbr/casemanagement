require 'rails_helper'
require 'spec_helper'

RSpec.describe IncomeDetailsController, :type => :controller do
	setup :activate_authlogic

	before :each do
		fake_login()
    	create_income()
    end

    def fake_login
		 @user = FactoryGirl.create(:user)
	     @user_session = FactoryGirl.create(:user_session)
	     AuditModule.set_current_user=(@user)
	     @client = FactoryGirl.create(:client)
		 session[:CLIENT_ID] = @client.id
	end

    def create_income
		@income = FactoryGirl.create(:income)
		create_income_detail()
	end

	def create_income_detail
		@income_detail = FactoryGirl.create(:income_detail, income_id: @income.id)
	end

	describe "GET #index" do
		it "populates a list of income_details" do
			incomes = @client.incomes
			incomes << @income
		    income_detail1 = FactoryGirl.create(:income_detail, income_id: @income.id)
		    income_detail2 = FactoryGirl.create(:income_detail, income_id: @income.id, check_type: 4837)
		    income_details = @income.income_details
		    get :index, income_id: @income.id
		    assigns(:income_details).should eq(income_details)
		end
	end

	describe "GET #new" do
		it "creates a new income_details object against the given income object" do
			income1 = @client.incomes.new
	 		get :new,income_id: @income.id
	 		assigns(:income) == income1
		end
	end

	describe "POST #create" do
		context "with valid attributes" do

			it "saves the new income_detail object in the database" do
				expect{ post :create,income_id: @income.id, income_detail: FactoryGirl.attributes_for(:income_detail)
					  }.to change(IncomeDetail,:count).by(1)
			end

			it "creates a record in income_details with created_by and updated_by fields with logged in user id" do
				expect{ post :create, income_id: @income.id, income_detail: FactoryGirl.attributes_for(:income_detail)
					  }.to change(IncomeDetail,:count).by(1) and IncomeDetail.last.created_by == @user.uid and IncomeDetail.last.updated_by == @user.uid
			end

			it "redirects to income_details index page on successful creation." do
				post :create, income_id: @income.id, income_detail: FactoryGirl.attributes_for(:income_detail)
				response.should redirect_to income_income_details_path(@income)
			end
		end

		context "with invalid attributes" do

			it "will not save the income_detail object in the database" do
				expect{ post :create, income_id: @income.id, income_detail: FactoryGirl.attributes_for(:invalid_income_data)
				      }.to_not change(IncomeDetail,:count)
			end

			it "re-renders the :new template when create is fails." do
				post :create, income_id: @income.id, income_detail: FactoryGirl.attributes_for(:invalid_income_data)
				response.should render_template :new
			end
		end
	end

	describe 'PUT #update' do
		context "valid attributes" do

			it "located the requested income_detail" do
				put :update, income_id: @income.id, id: @income_detail, income_detail: FactoryGirl.attributes_for(:income_detail)
				assigns(:income_detail).should == @income_detail
			end

			it "updates income_detail object when valid attributes are passed" do
				put :update, income_id: @income.id, id: @income_detail, income_detail: FactoryGirl.attributes_for(:income_detail, check_type: 4837)
				@income_detail.reload
				@income_detail.check_type.should == 4837
		    end

		    it "updates a record with updated_by fields with logged in user id" do
				 logged_in_user = FactoryGirl.create(:user,login: "update_user", name: "update_user", email_id: "update_user@email.com")
	     		 @user_session = FactoryGirl.create(:user_session, login: "update_user")
	             AuditModule.set_current_user=(logged_in_user)
	             put :update, income_id: @income.id, id: @income_detail, income_detail: FactoryGirl.attributes_for(:income_detail, check_type: 4837)
	             assigns(:income_detail).updated_by.should == logged_in_user.id
			end

			it "updates a record but the created_by field remains unchanged" do
				 logged_in_user = FactoryGirl.create(:user,login: "update_user", name: "update_user", email_id: "update_user@email.com")
	     		 @user_session = FactoryGirl.create(:user_session, login: "update_user")
	             AuditModule.set_current_user=(logged_in_user)
	             put :update, income_id: @income.id, id: @income_detail, income_detail: FactoryGirl.attributes_for(:income_detail, check_type: 4837)
	             assigns(:income_detail).created_by.should == @user.uid
			end

		   	it "redirects to the show page after successful update" do
		    	put :update, income_id: @income.id, id: @income_detail, income_detail: FactoryGirl.attributes_for(:income_detail, check_type: 4837)
		    	response.should redirect_to income_income_details_path(@income)
		    end
		end

		context "invalid attributes" do
			it "locates the requested @income_detail" do
				put :update, income_id: @income.id, id: @income_detail, income_detail: FactoryGirl.attributes_for(:invalid_income_detail_data)
				assigns(:income_detail).should == @income_detail
			end

			it "does not update income_detail record when invalid attributes are passed." do
				put :update, income_id: @income.id, id: @income_detail, income_detail: FactoryGirl.attributes_for(:invalid_income_detail_data)
				@income_detail.reload
				@income_detail.check_type.should == 4385
			end

			it "re-renders the edit method when update is failed." do
				put :update, income_id: @income.id, id: @income_detail, income_detail: FactoryGirl.attributes_for(:invalid_income_detail_data)
				response.should render_template :edit
			end
		end
	end

	describe "DELETE #destroy" do
		it "destroys the requested income record" do
	      expect {
	        delete :destroy, income_id: @income.id, id: @income_detail
	      }.to change(IncomeDetail, :count).by(-1)
	    end

	    it "redirects to the income_details index on successful delete" do
	      delete :destroy, income_id: @income.id, id: @income_detail
	      response.should redirect_to income_income_details_path(@income)
	    end
	end

end