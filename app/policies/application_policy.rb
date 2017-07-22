class ApplicationPolicy
	# Author: Manoj Patil
	# Date : 07/08/2014
	# Description : All policy files for controller will inherit this application policy file.
    #               Initialization checks for Authentication is done before Authorization.
	#               when controller calls -authorize @<model variable> then logged in user
	#


  attr_reader :user, :record

  def initialize(user, record)
    #Manoj 07/08/2014
    # Making sure Authentication is done and initialising for authorization
    if user
       @user = user
       @record = record
    else
       raise Pundit::NotAuthorizedError
    end
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  # new action calls create action, so in the descendent policy files - we don't have mention rule for new action.

  def new?
    create?
  end

  def create?
    false
  end


  # edit action calls create action, so in the descendent policy files - we don't have mention rule for new action.
  def edit?
    update?
  end

  def update?
    false
  end


  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end
end

