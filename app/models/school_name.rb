class SchoolName < CodetableItem
	# Authros; Vishal & Manoj
	#Date : 08/07/2014
	# Description: School Names belongs to parent_id column of the codetable_items and Parent_type = CodetableItem.
	#School Name is retrived by parent_id and parent_type
	#Example : for Elementary school type (2192) all school name belonging to parent_id = 2192 and parent_type= CodetableItem are shown.
	belongs_to :parent, polymorphic: true
end