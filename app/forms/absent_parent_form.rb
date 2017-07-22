
	class AbsentParentForm < Reform::Form
		# include DSL
		include Composition
	    include Reform::Form::ActiveModel
	    # include Reform::Form::ActiveRecord
	     HUMANIZED_ATTRIBUTES = {

      relationship_type:"Relationship Type",
      court_order_number: "Court Order Number",
      court_ordered_amount: "Court Order Amount",
      amount_collected: "Amount Collected",
      deprivation_code: "Deprivation Reason",
      child_support_referral: "Child Support Referral"


    }

  def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

	    properties [:from_client_id,:to_client_id, :relationship_type], on: :client_relationship
	    properties [:court_order_number,:court_ordered_amount, :amount_collected,:good_cause,:married_at_birth,:paternity_established,:deprivation_code,:child_support_referral], on: :client_parental_rspability

	    model :client_relationship, on: :client_relationship

	    validates_presence_of  :from_client_id,:to_client_id, :relationship_type,message: "is required"
	    validates_presence_of :deprivation_code,message: "is required"
	    validate :good_cause_present?


	    def good_cause_present?
	    	relationship_type = client_relationship.relationship_type
	    	if relationship_type == 5940 || relationship_type == 5941
		    	if good_cause.present?
	                return true
				else
					errors[:base] << "Good cause is required if its absent father or mother."
					return false
				end
			else
				return true
			end
		end


	end


