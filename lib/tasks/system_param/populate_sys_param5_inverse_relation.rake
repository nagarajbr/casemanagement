# Author : Manoj Patil
#  Date : 09/15/2014
namespace :populate_sys_param5 do
	desc "Inverse Relation"
	task :inverse_relation_2 => :environment do
		# inverse relation
		SystemParam.where(id: 103).update_all(key: "5953", value:"6003",description:"Inverse Relation for Child Step is Step Parent")
		SystemParam.where(id: 117).update_all(key:"5996" ,value:"6011")
		SystemParam.create(system_param_categories_id: 5,key:"5944",value:"6009",description:"Inverse relation for Absent Parent is- child",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5947",value:"5947",description:"Inverse relation for Boarder is- Boarder",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5959",value:"5959",description:"Inverse relation for First Cousin   is- First Cousin  ",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5966",value:"5975",description:"Inverse relation for Great Aunt/Uncle  is- Great Niece/Nephew",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5975",value:"5966",description:"Inverse relation for Great Niece/Nephew is- Great Aunt/Uncle",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5971",value:"5974",description:"Inverse relation for Great Great Aunt/Uncle  is- Great Great Niece/Nephew",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5974",value:"5971",description:"Inverse relation for Great Great Niece/Nephew is- Great Great Aunt/Uncle",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5976",value:"5976",description:"Inverse relation for Half Sibling  is- Half Sibling ",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5980",value:"5980",description:"Inverse relation for Other Non-Relative  is- Other Non-Relative",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5981",value:"5981",description:"Inverse relation for Other Relative  is- Other Relative",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5982",value:"5982",description:"Inverse relation for Other-Court Order Custody  is- Other-Court Order Custody",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5984",value:"5984",description:"Inverse relation for Roommate  is- Roommate",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5985",value:"5985",description:"Inverse relation for Second Cousin   is- Second Cousin ",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5988",value:"5988",description:"Inverse relation for Sibling   is- Sibling",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5990",value:"5990",description:"Inverse relation for Spouse - Common Law   is- Spouse - Common Law ",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5991",value:"5991",description:"Inverse relation for Spouse - Legal Ceremony   is- Spouse - Legal Ceremony",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5992",value:"6002",description:"Inverse relation for Step Aunt/Uncle   is- Step Niece/Nephew",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"6002",value:"5992",description:"Inverse relation for Step Niece/Nephew  is- Step Aunt/Uncle ",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"5993",value:"5993",description:"Inverse relation for Step First Cousin  is- Step First Cousin ",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"6006",value:"6006",description:"Inverse relation for Step Sibling  is- Step Sibling ",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"6008",value:"6008",description:"Inverse relation for Unknown  is- Unknown",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"6014",value:"5962",description:"Inverse relation for Gr Gr Gr  Grandparent  is- Gr Gr Gr  Grandchild",created_by: 1,updated_by: 1)
	end
end