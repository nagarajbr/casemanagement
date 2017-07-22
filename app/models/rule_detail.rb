class RuleDetail < ActiveRecord::Base
	def self.get_rule_details_by_rule_id_and_codetable_id(arg_rule_id, arg_codetable_id)
		where("rule_id =? and codetable_items_id =?",arg_rule_id, arg_codetable_id)
	end
end
