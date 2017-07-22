require 'rails_helper'

RSpec.describe ResourceDetailsController, :type => :controller do

	setup :activate_authlogic

	before :each do
    	fake_login()
    end

    def fake_login
		@user = FactoryGirl.create(:user)
	    @user_session = FactoryGirl.create(:user_session)
	    AuditModule.set_current_user=(@user)
	    client = FactoryGirl.create(:client)
		session[:CLIENT_ID] = client.id
		@resource = client.shared_resources.create(FactoryGirl.attributes_for(:resource, date_assert_acquired: "2014-08-01", date_assert_disposed: "2014-08-31"))
		@resource_detail = FactoryGirl.create(:resource_detail, resource_id: @resource.id)
	end

	describe "GET #index" do
		it "populates a list of resource_details" do
			resource_detail1 = FactoryGirl.create(:resource_detail, resource_id: @resource.id)
		    resource_detail2 = FactoryGirl.create(:resource_detail, resource_id: @resource.id, resource_value: "2014-08-11")
		    resource_details = @resource.resource_details
		    resource_details << resource_detail1
		    resource_details << resource_detail2
		    get :index, resource_id: @resource.id
		    assigns(:resource_details).should eq(resource_details)
		end
	end

	describe "GET #new" do
		it "creates a new resource_details object against the given resource object" do
			resource1 = @resource.resource_details.new
	 		get :new,resource_id: @resource.id
	 		assigns(:resource) == resource1
		end
	end

	describe "POST #create" do
		context "with valid attributes" do

			it "saves the new resource_detail object in the database" do
				expect{ post :create,resource_id: @resource.id, resource_detail: FactoryGirl.attributes_for(:resource_detail)
					  }.to change(ResourceDetail,:count).by(1)
			end

			it "creates a record in resource_details with created_by and updated_by fields with logged in user id" do
				expect{ post :create, resource_id: @resource.id, resource_detail: FactoryGirl.attributes_for(:resource_detail)
					  }.to change(ResourceDetail,:count).by(1) and ResourceDetail.last.created_by == @user.uid and ResourceDetail.last.updated_by == @user.uid
			end

			it "redirects to resource_details index page on successful creation." do
				post :create, resource_id: @resource.id, resource_detail: FactoryGirl.attributes_for(:resource_detail)
				response.should redirect_to resource_resource_details_path(@resource)
			end
		end

		context "with invalid attributes" do

			it "will not save the resource_detail object in the database" do
				expect{ post :create, resource_id: @resource.id, resource_detail: FactoryGirl.attributes_for(:invalid_resource_detail_data)
				      }.to_not change(ResourceDetail,:count)
			end

			it "re-renders the :new template when create is fails." do
				post :create, resource_id: @resource.id, resource_detail: FactoryGirl.attributes_for(:invalid_resource_detail_data)
				response.should render_template :new
			end
		end
	end

	describe 'PUT #update' do
		context "valid attributes" do

			it "locate the right resource_detail object for update" do
				put :update, resource_id: @resource.id, id: @resource_detail, resource_detail: FactoryGirl.attributes_for(:resource_detail)
				assigns(:resource_detail).should == @resource_detail
			end

			it "updates resource_detail object when valid attributes are passed" do
				put :update, resource_id: @resource.id, id: @resource_detail, resource_detail: FactoryGirl.attributes_for(:resource_detail, resource_value: 138.18)
				@resource_detail.reload
				@resource_detail.resource_value.should == 138.18
		    end

		    it "updates a record with updated_by fields with logged in user id" do
				 logged_in_user = FactoryGirl.create(:user,login: "update_user", name: "update_user", email_id: "update_user@email.com")
	     		 @user_session = FactoryGirl.create(:user_session, login: "update_user")
	             AuditModule.set_current_user=(logged_in_user)
	             put :update, resource_id: @resource.id, id: @resource_detail, resource_detail: FactoryGirl.attributes_for(:resource_detail, resource_value: 138.18)
	             assigns(:resource_detail).updated_by.should == logged_in_user.id
			end

			it "updates a record but the created_by field remains unchanged" do
				 logged_in_user = FactoryGirl.create(:user,login: "update_user", name: "update_user", email_id: "update_user@email.com")
	     		 @user_session = FactoryGirl.create(:user_session, login: "update_user")
	             AuditModule.set_current_user=(logged_in_user)
	             put :update, resource_id: @resource.id, id: @resource_detail, resource_detail: FactoryGirl.attributes_for(:resource_detail, resource_value: 138.18)
	             assigns(:resource_detail).created_by.should == @user.uid
			end

		   	it "redirects to the show page after successful update" do
		    	put :update, resource_id: @resource.id, id: @resource_detail, resource_detail: FactoryGirl.attributes_for(:resource_detail, resource_value: 138.18)
		    	response.should redirect_to resource_resource_details_path(@resource)
		    end
		end

		context "invalid attributes" do
			it "locates the requested @resource_detail" do
				put :update, resource_id: @resource.id, id: @resource_detail, resource_detail: FactoryGirl.attributes_for(:invalid_resource_detail_data, resource_value: 138.18)
				assigns(:resource_detail).should eq(@resource_detail)
			end

			it "does not update resource_detail record when invalid attributes are passed." do
				put :update, resource_id: @resource.id, id: @resource_detail, resource_detail: FactoryGirl.attributes_for(:invalid_resource_detail_data, resource_value: 138.18)
				@resource_detail.reload
				@resource_detail.resource_value.should == 12345.78
			end

			it "re-renders the edit method when update is failed." do
				put :update, resource_id: @resource.id, id: @resource_detail, resource_detail: FactoryGirl.attributes_for(:invalid_resource_detail_data, resource_value: 138.18)
				response.should render_template :edit
			end
		end
	end

	describe "DELETE #destroy" do
		it "destroys the requested resource_detail record" do
	      expect {
	        delete :destroy, resource_id: @resource.id, id: @resource_detail
	      }.to change(ResourceDetail, :count).by(-1)
	    end

	    it "redirects to the resource_details index on successful delete" do
	      delete :destroy, resource_id: @resource.id, id: @resource_detail
	      response.should redirect_to resource_resource_details_path(@resource)
	    end
	end

end
