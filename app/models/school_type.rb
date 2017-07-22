class SchoolType < CodetableItem
	# Authros; Vishal & Manoj
	#Date : 08/07/2014
	# Description: School type has many school_names by referring to codetable_items field parent_id.
	# Example :for Elementary school type (2192) all school name belonging to parent_id = 2192 and parent_type= CodetableItem are retrieved.
	has_many :school_names, as: :parent

end