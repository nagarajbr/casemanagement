require 'rails_helper'

RSpec.describe ClientsShareController, :type => :controller do

	setup :activate_authlogic

	before :each do
    	fake_login()
    end

    def fake_login
		@user = FactoryGirl.create(:user)
	    @user_session = FactoryGirl.create(:user_session)
	    AuditModule.set_current_user=(@user)
	    @client = FactoryGirl.create(:client)
	    @client1 = FactoryGirl.create(:client, first_name: "Kiran", last_name: "Chamarthi", gender: 4479, dob: "1990-08-11", ssn: 123456789)
		session[:CLIENT_ID] = @client.id
	end

	describe "GET #share_search" do
		it " should retrieve the right client, upon the search parameters" do
			params =  Hash.new
			params[:ssn] = 123456789
			clients = Client.search(params)
			get :share_search, type: "income", type_id: 1, ssn: 123456789
			assigns(:clients).should eq(clients)
		end
	end

	describe "GET #create_share for income" do

		before :each do
    		@income = @client.incomes.create(FactoryGirl.attributes_for(:income))
        end

		it "should insert a record in client_incomes table when type is income" do
			
				expect{ get :create_share, type: "income", type_id: @income.id, id: @client1.id
					  }.to change(ClientIncome,:count).by(1)
		end	

		it "should not share the income across client if it's already shared" do
		    ClientIncome.create(client_id: @client1.id, income_id: @income.id)			    
				expect{ get :create_share, type: "income", type_id: @income.id, id: @client1.id
					  }.to_not change(ClientIncome,:count)
		end

		it "should not insert a record in client_incomes table when search client is same as the client for which income has been created" do
				expect{ get :create_share, type: "income", type_id: @income.id, id: @client.id
					  }.to_not change(ClientIncome,:count)				  
		end

		it "redirects to income show page on successful creation." do				
				get :create_share, type: "income", type_id: @income.id, id: @client1.id 
				response.should redirect_to show_shared_income_path(@income.id) 
		end
	end

	describe "GET #create_share for resource" do

		before :each do
    		@resource = @client.shared_resources.create(FactoryGirl.attributes_for(:resource))
        end

		it "should insert a record in client_incomes table when type is resource" do
			
				expect{ get :create_share, type: "resource", type_id: @resource.id, id: @client1.id
					  }.to change(ClientResource,:count).by(1)
		end	

		it "should not share the resource across client if it's already shared" do
		    ClientResource.create(client_id: @client1.id, resource_id: @resource.id)			    
				expect{ get :create_share, type: "resource", type_id: @resource.id, id: @client1.id
					  }.to_not change(ClientResource,:count)
		end

		it "should not insert a record in client_incomes table when search client is same as the client for which resource has been created" do
				expect{ get :create_share, type: "resource", type_id: @resource.id, id: @client.id
					  }.to_not change(ClientResource,:count)				  
		end

		it "redirects to resource show page on successful creation." do				
				get :create_share, type: "resource", type_id: @resource.id, id: @client1.id 
				response.should redirect_to show_shared_resource_path(@resource.id) 
		end
	end

	describe "GET #create_share for expense" do

		before :each do
    		@expense = @client.expenses.create(FactoryGirl.attributes_for(:expense))
        end

		it "should insert a record in client_incomes table when type is expense" do
			
				expect{ get :create_share, type: "expense", type_id: @expense.id, id: @client1.id
					  }.to change(ClientExpense,:count).by(1)
		end	

		it "should not share the expense across client if it's already shared" do
		    ClientExpense.create(client_id: @client1.id, expense_id: @expense.id)			    
				expect{ get :create_share, type: "expense", type_id: @expense.id, id: @client1.id
					  }.to_not change(ClientExpense,:count)
		end

		it "should not insert a record in client_incomes table when search client is same as the client for which expense has been created" do
				expect{ get :create_share, type: "expense", type_id: @expense.id, id: @client.id
					  }.to_not change(ClientExpense,:count)				  
		end

		it "redirects to expense show page on successful creation." do				
				get :create_share, type: "expense", type_id: @expense.id, id: @client1.id 
				response.should redirect_to show_shared_expense_path(@expense.id) 
		end
	end	

	describe "DELETE #destroy for income" do
		it "destroys the requested client_income record" do
			income = @client.incomes.create(FactoryGirl.attributes_for(:income))
			client_income = ClientIncome.create(client_id: @client1.id, income_id: income.id)
	        expect {
	        	delete :destroy, type: "income", type_id: income.id, id: @client1.id
	        }.to change(ClientIncome, :count).by(-1)
	    end

	    it "destroys the corresponding client_resources records on income delete" do
	      income = @client.incomes.create(FactoryGirl.attributes_for(:income))
			client_income = ClientIncome.create(client_id: @client1.id, income_id: income.id)
	        expect {
	        	income.destroy
	        }.to change(ClientIncome, :count).by(-2)
	    end   

	    it "destroys the corresponding client_resources records on client record delete" do
	      income = @client.incomes.create(FactoryGirl.attributes_for(:income))
			client_income = ClientIncome.create(client_id: @client1.id, income_id: income.id)
	        expect {
	        	@client.destroy
	        }.to change(ClientIncome, :count).by(-1)
	    end

	    it "destroys the corresponding client_resources records on share client record delete" do
	      income = @client.incomes.create(FactoryGirl.attributes_for(:income))
			client_income = ClientIncome.create(client_id: @client1.id, income_id: income.id)
	        expect {
	        	@client1.destroy
	        }.to change(ClientIncome, :count).by(-1)
	    end

	    it "redirects to the income show page on successful delete" do
	    	income = @client.incomes.create(FactoryGirl.attributes_for(:income))
			client_income = ClientIncome.create(client_id: @client1.id, income_id: income.id)
			delete :destroy, type: "income", type_id: income.id, id: @client1.id  
	        response.should redirect_to show_shared_income_path(income.id)
	    end
	end

	describe "DELETE #destroy for resource" do
		it "destroys the requested client_resource record" do
			resource = @client.shared_resources.create(FactoryGirl.attributes_for(:resource))
			client_resource = ClientResource.create(client_id: @client1.id, resource_id: resource.id)
	        expect {
	        	delete :destroy, type: "resource", type_id: resource.id, id: @client1.id
	        }.to change(ClientResource, :count).by(-1)
	    end

	    it "destroys the corresponding client_resources records on resource delete" do
	      resource = @client.shared_resources.create(FactoryGirl.attributes_for(:resource))
			client_resource = ClientResource.create(client_id: @client1.id, resource_id: resource.id)
	        expect {
	        	resource.destroy
	        }.to change(ClientResource, :count).by(-2)
	    end   

	    it "destroys the corresponding client_resources records on client record delete" do
	      resource = @client.shared_resources.create(FactoryGirl.attributes_for(:resource))
			client_resource = ClientResource.create(client_id: @client1.id, resource_id: resource.id)
	        expect {
	        	@client.destroy
	        }.to change(ClientResource, :count).by(-1)
	    end

	    it "destroys the corresponding client_resources records on share client record delete" do
	      resource = @client.shared_resources.create(FactoryGirl.attributes_for(:resource))
			client_resource = ClientResource.create(client_id: @client1.id, resource_id: resource.id)
	        expect {
	        	@client1.destroy
	        }.to change(ClientResource, :count).by(-1)
	    end

	    it "redirects to the resource show page on successful delete" do
	    	resource = @client.shared_resources.create(FactoryGirl.attributes_for(:resource))
			client_resource = ClientResource.create(client_id: @client1.id, resource_id: resource.id)
			delete :destroy, type: "resource", type_id: resource.id, id: @client1.id  
	        response.should redirect_to show_shared_resource_path(resource.id)
	    end
	end

	describe "DELETE #destroy for expense" do
		it "destroys the requested client_expense record" do
			expense = @client.expenses.create(FactoryGirl.attributes_for(:expense))
			client_expense = ClientExpense.create(client_id: @client1.id, expense_id: expense.id)
	        expect {
	        	delete :destroy, type: "expense", type_id: expense.id, id: @client1.id
	        }.to change(ClientExpense, :count).by(-1)
	    end

	    it "destroys the corresponding client_expenses records on expense delete" do
	      expense = @client.expenses.create(FactoryGirl.attributes_for(:expense))
			client_expense = ClientExpense.create(client_id: @client1.id, expense_id: expense.id)
	        expect {
	        	expense.destroy
	        }.to change(ClientExpense, :count).by(-2)
	    end   

	    it "destroys the corresponding client_expenses records on client record delete" do
	      expense = @client.expenses.create(FactoryGirl.attributes_for(:expense))
			client_expense = ClientExpense.create(client_id: @client1.id, expense_id: expense.id)
	        expect {
	        	@client.destroy
	        }.to change(ClientExpense, :count).by(-1)
	    end

	    it "destroys the corresponding client_expenses records on share client record delete" do
	      expense = @client.expenses.create(FactoryGirl.attributes_for(:expense))
			client_expense = ClientExpense.create(client_id: @client1.id, expense_id: expense.id)
	        expect {
	        	@client1.destroy
	        }.to change(ClientExpense, :count).by(-1)
	    end

	    it "redirects to the expense show page on successful delete" do
	    	expense = @client.expenses.create(FactoryGirl.attributes_for(:expense))
			client_expense = ClientExpense.create(client_id: @client1.id, expense_id: expense.id)
			delete :destroy, type: "expense", type_id: expense.id, id: @client1.id  
	        response.should redirect_to show_shared_expense_path(expense.id)
	    end
	end

end
