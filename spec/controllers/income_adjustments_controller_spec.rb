require 'rails_helper'
require 'spec_helper'

RSpec.describe IncomeDetailAdjustReasonsController, :type => :controller do
	setup :activate_authlogic

	before :each do
		fake_login()
    	create_parent_objects()
    end

    def fake_login
		 @user = FactoryGirl.create(:user)
	     @user_session = FactoryGirl.create(:user_session)
	     AuditModule.set_current_user=(@user)
	     @client = FactoryGirl.create(:client)
		 session[:CLIENT_ID] = @client.id
	end

    def create_parent_objects
		@income = FactoryGirl.create(:income)
		@income_detail = FactoryGirl.create(:income_detail, income_id: @income.id, gross_amt: 38.18)
		@income_adjust_reason = FactoryGirl.create(:income_detail_adjust_reason, income_detail_id: @income_detail.id)
	end

	describe "GET #index" do
		it "populates a list of income_detail_adjust_reason" do
			adjustment_reasons = @income_detail.income_detail_adjust_reasons
			adjust_reasons1 = 	FactoryGirl.create(:income_detail_adjust_reason, income_detail_id: @income_detail.id)
			adjust_reasons2 = 	FactoryGirl.create(:income_detail_adjust_reason, income_detail_id: @income_detail.id, adjusted_reason: 4439)
			adjustment_reasons << adjust_reasons1
			adjustment_reasons << adjust_reasons2
			get :index, income_detail_id: @income_detail.id
		    assigns(:adjust_reasons).should eq(adjustment_reasons)
		end
	end

	describe "GET #new" do
		it "creates a new income_detail_adjust_reason object against the given income_detail object" do
			income_detail_adjust_reason = @income_detail.income_detail_adjust_reasons.new
	 		get :new, income_detail_id: @income_detail.id
	 		assigns(:adjust_reason) == income_detail_adjust_reason
		end
	end

	describe "POST #create" do
		context "with valid attributes" do

			it "saves the new income_detail_adjust_reason object in the database" do
				expect{ post :create, income_detail_id: @income_detail.id,
					    income_detail_adjust_reason:
					    FactoryGirl.attributes_for(:income_detail_adjust_reason, income_detail_id: @income_detail.id)
					  }.to change(IncomeDetailAdjustReason,:count).by(1)
			end

			it "will not create income_detail_adjust_reason object in the database for adjusted_amount and adjusted_reason are nil" do
				expect{ post :create, income_detail_id: @income_detail.id,
						income_detail_adjust_reason:
						FactoryGirl.attributes_for(:income_detail_adjust_reason, income_detail_id: @income_detail.id,
							adjusted_amount: nil, adjusted_reason: nil)
					  }.to change(IncomeDetailAdjustReason,:count).by(0)
			end

			it "will create income_detail_adjust_reason object in the database for adjusted_amount as nil and adjusted_reason as not nil" do
				expect{ post :create, income_detail_id: @income_detail.id,
						income_detail_adjust_reason:
							FactoryGirl.attributes_for(
									:income_detail_adjust_reason, income_detail_id: @income_detail.id, adjusted_amount: nil)
					  }.to change(IncomeDetailAdjustReason,:count).by(1)
			end

			it "will not create income_detail_adjust_reason object in the database for adjusted_amount as not nil and adjusted_reason as nil" do
				expect{ post :create, income_detail_id: @income_detail.id,
						income_detail_adjust_reason:
							 FactoryGirl.attributes_for(
									:income_detail_adjust_reason, income_detail_id: @income_detail.id, adjusted_reason: nil)
					  }.to change(IncomeDetailAdjustReason,:count).by(1)
			end

			it "creates a record in income_detail_adjust_reasons with created_by fields as logged in user id" do
				post :create, income_detail_id: @income_detail.id, income_detail_adjust_reason: FactoryGirl.attributes_for(:income_detail_adjust_reason, income_detail_id: @income_detail.id)
				IncomeDetailAdjustReason.last.created_by.should == @user.uid and IncomeDetailAdjustReason.last.updated_by == @user.uid
			end

			it "creates a record in income_detail_adjust_reasons with updated_by fields as logged in user id" do
				post :create, income_detail_id: @income_detail.id, income_detail_adjust_reason: FactoryGirl.attributes_for(:income_detail_adjust_reason, income_detail_id: @income_detail.id)
				IncomeDetailAdjustReason.last.updated_by == @user.uid
			end

			it "redirects to income_detail_adjust_reasons index page on successful creation." do
				post :create, income_detail_id: @income_detail.id, income_detail_adjust_reason: FactoryGirl.attributes_for(:income_detail_adjust_reason, income_detail_id: @income_detail.id)
				response.should redirect_to income_detail_income_detail_adjust_reasons_path(@income_detail)
			end
		end

		context "with invalid attributes" do

			it "will not save the income_detail object in the database" do
				expect{ post :create, income_detail_id: @income_detail.id, income_detail_adjust_reason: FactoryGirl.attributes_for(:invalid_income_adjustments_data)
				      }.to_not change(IncomeDetailAdjustReason,:count)
			end

			it "redirects to the index page when create fails." do
				post :create, income_detail_id: @income_detail.id,
					income_detail_adjust_reason:
						FactoryGirl.attributes_for(:invalid_income_adjustments_data)
				response.should redirect_to income_detail_income_detail_adjust_reasons_path(@income_detail)
			end
		end
	end

	describe 'PUT #update' do
		context "valid attributes" do

			it "locate the right income_detail_adjust_reasons object to be updated" do
				put :update, income_detail_id: @income_detail.id, id: @income_adjust_reason.id,
					income_detail_adjust_reason:
						FactoryGirl.attributes_for(:income_detail_adjust_reason, income_detail_id: @income_detail.id)
				assigns(:adjust_reason).should == @income_adjust_reason
			end

			it "updates income_detail_adjust_reasons object when valid attributes are passed" do
				put :update, income_detail_id: @income_detail.id, id: @income_adjust_reason.id,
						income_detail_adjust_reason:
							FactoryGirl.attributes_for(:income_detail_adjust_reason, income_detail_id: @income_detail.id,
									adjusted_reason: 4439)
				@income_adjust_reason.reload
				@income_adjust_reason.adjusted_reason.should == 4439
		    end

		    it "updates a record with updated_by field with logged in user id" do
				 logged_in_user = FactoryGirl.create(:user,login: "update_user", name: "update_user", email_id: "update_user@email.com")
	     		 @user_session = FactoryGirl.create(:user_session, login: "update_user")
	             AuditModule.set_current_user=(logged_in_user)
	             put :update, income_detail_id: @income_detail.id, id: @income_adjust_reason.id,
						income_detail_adjust_reason:
							FactoryGirl.attributes_for(:income_detail_adjust_reason, income_detail_id: @income_detail.id,
									adjusted_reason: 4439)
	             assigns(:adjust_reason).updated_by.should == logged_in_user.id
			end

			it "updates a record but the created_by field remains unchanged" do
				 logged_in_user = FactoryGirl.create(:user,login: "update_user", name: "update_user", email_id: "update_user@email.com")
	     		 @user_session = FactoryGirl.create(:user_session, login: "update_user")
	             AuditModule.set_current_user=(logged_in_user)
	             put :update, income_detail_id: @income_detail.id, id: @income_adjust_reason.id,
						income_detail_adjust_reason:
							FactoryGirl.attributes_for(:income_detail_adjust_reason, income_detail_id: @income_detail.id,
									adjusted_reason: 4439)
	             assigns(:adjust_reason).created_by.should == @user.uid
			end

		   	it "redirects to the show page after successful update" do
		    	put :update, income_detail_id: @income_detail.id, id: @income_adjust_reason.id,
						income_detail_adjust_reason:
							FactoryGirl.attributes_for(:income_detail_adjust_reason, income_detail_id: @income_detail.id,
									adjusted_reason: 4439)
		    	response.should redirect_to income_detail_income_detail_adjust_reasons_path(@income_detail,@income_adjust_reason)
		    end
		end

		context "invalid attributes" do
			it "locate the right income_detail_adjust_reasons object to be updated" do
				put :update, income_detail_id: @income_detail.id, id: @income_adjust_reason.id,
						income_detail_adjust_reason:
							FactoryGirl.attributes_for(:invalid_income_adjustments_data)
				assigns(:adjust_reason).should == @income_adjust_reason
			end

			it "does not update income_detail_adjust_reasons record when invalid attributes are passed." do
				put :update, income_detail_id: @income_detail.id, id: @income_adjust_reason.id,
						income_detail_adjust_reason:
							FactoryGirl.attributes_for(:invalid_income_adjustments_data)
				@income_adjust_reason.reload
				@income_adjust_reason.adjusted_reason.should == 4454
			end

			it "re-renders the edit method when update is failed." do
				put :update, income_detail_id: @income_detail.id, id: @income_adjust_reason.id,
						income_detail_adjust_reason:
							FactoryGirl.attributes_for(:invalid_income_adjustments_data)
				response.should render_template :edit
			end
		end
	end

	describe "DELETE #destroy" do
		it "destroys the requested income_detail_adjust_reasons record" do
	      expect {
	        delete :destroy, income_detail_id: @income_detail.id, id: @income_adjust_reason.id
	      }.to change(IncomeDetailAdjustReason, :count).by(-1)
	    end

	    it "redirects to the income_detail_adjust_reasons index on successful delete" do
	      delete :destroy, income_detail_id: @income_detail.id, id: @income_adjust_reason.id
	      response.should redirect_to income_detail_income_detail_adjust_reasons_path(@income_detail,@income_adjust_reason)
	    end
	end
end