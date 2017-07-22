class AdultStruct
	#  Author Thirumal
	attr_accessor :parent_id, :caretaker_id, :children_struct, :status, :minor_parent
	def initialize
		@children_struct = []
	end
end