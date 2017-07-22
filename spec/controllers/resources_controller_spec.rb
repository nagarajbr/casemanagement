require 'rails_helper'
require 'spec_helper'

RSpec.describe ResourcesController, :type => :controller do
	setup :activate_authlogic

	before :each do
    	fake_login()
    end

    def fake_login
		@user = FactoryGirl.create(:user)
	    @user_session = FactoryGirl.create(:user_session)
	    AuditModule.set_current_user=(@user)
	    @client = FactoryGirl.create(:client)
		session[:CLIENT_ID] = @client.id
	end

	describe "GET #index" do
		it "populates an array of resources" do
			@client.shared_resources.create(FactoryGirl.attributes_for(:resource))
		    @client.shared_resources.create(FactoryGirl.attributes_for(:resource))
		    resources = @client.shared_resources
		    get :index
		    assigns(:resources).should eq(resources)
		end
	end

	describe "GET #new" do
		it "creates a new resource object for selected client" do
			resource1 = @client.shared_resources.new
	 		get :new
	 		assigns(:resource) == resource1
		end
	end

	describe "POST #create" do
		context "with valid attributes" do
			it "saves the new resource object in the database" do
				expect{ post :create, resource: FactoryGirl.attributes_for(:resource, client: @client)
					  }.to change(Resource,:count).by(1)
			end

			it "on creating the resource object in the database a record gets inserted in the client_resources table" do
				expect{ post :create, resource: FactoryGirl.attributes_for(:resource, client: @client)
					  }.to change(ClientResource,:count).by(1)
			end

			it "creates a record with created_by and updated_by fields with logged in user id" do
				post :create, resource: FactoryGirl.attributes_for(:resource, client: @client)
				Resource.last.created_by == @user.uid and Resource.last.updated_by == @user.uid
			end

			it "redirects to resource index page on successful creation." do
				post :create, resource: FactoryGirl.attributes_for(:resource, client: @client)
				response.should redirect_to resources_path
			end
		end

		context "with invalid attributes" do
			it "will not save the resource object in the database" do
				expect{ post :create, resource: FactoryGirl.attributes_for(:invalid_resource_data, client: @client)
				      }.to_not change(Resource,:count)
			end

			it "re-renders the :new template when create fails." do
				post :create, resource: FactoryGirl.attributes_for(:invalid_resource_data, client: @client)
				response.should render_template :new
			end
		end
	end

	describe 'PUT #update' do
		before :each do
			@resource = @client.shared_resources.create(FactoryGirl.attributes_for(:resource))
    	end
		context "valid attributes" do
			it "locate the right resource object for update" do
				put :update, id: @resource, resource: FactoryGirl.attributes_for(:resource)
				assigns(:resource).should == @resource
			end

			it "updates resource object when valid attributes are passed" do
				put :update, id: @resource, resource: FactoryGirl.attributes_for(:resource, client: @client, resource_type: 2435)
				@resource.reload
				@resource.resource_type.should == 2435
		    end

		    it "updates a record with updated_by fields with logged in user id and created_by field remains unchanged" do
				 logged_in_user = FactoryGirl.create(:user,login: "update_user", name: "update_user", email_id: "update_user@email.com")
	     		 @user_session = FactoryGirl.create(:user_session, login: "update_user")
	             AuditModule.set_current_user=(logged_in_user)
	             put :update, id: @resource, resource: FactoryGirl.attributes_for(:resource, client: @client, resource_type: 2435)
	             assigns(:resource).updated_by.should == logged_in_user.id and assigns(:resource).created_by.should == @user.uid
			end

		    it "redirects to the show page after successful update" do
		    	put :update, id: @resource, resource: FactoryGirl.attributes_for(:resource, client: @client, resource_type: 2435)
		    	response.should redirect_to @resource
		    end
		end

		context "invalid attributes" do
			it "locate the requested resource for update" do
				put :update, id: @resource, resource: FactoryGirl.attributes_for(:invalid_resource_data, client: @client)
				assigns(:resource).should == @resource
			end

			it "does not update resource object when invalid attributes are passed." do
				put :update, id: @resource, resource: FactoryGirl.attributes_for(:invalid_resource_data, client: @client)
				@resource.reload
				@resource.resource_type.should == 2449
			end

			it "re-renders the edit method when update is failed." do
				put :update, id: @resource, resource: FactoryGirl.attributes_for(:invalid_resource_data, client: @client)
				response.should render_template :edit
			end
		end
	end

	describe "DELETE #destroy" do
		before :each do
			@resource = @client.shared_resources.create(FactoryGirl.attributes_for(:resource))
    	end

	    it "destroys the requested resource record" do
	      expect {
	        delete :destroy, id: @resource
	      }.to change(Resource, :count).by(-1)
	    end

	    it "destroys the corresponding client_resources record" do
	      expect {
	        delete :destroy, id: @resource
	      }.to change(ClientResource, :count).by(-1)
	    end

	    it "redirects to the resources index on successful delete" do
	      delete :destroy, id: @resource
	      response.should redirect_to resources_path
	    end
	end

end
