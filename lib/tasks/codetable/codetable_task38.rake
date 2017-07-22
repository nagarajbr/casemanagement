namespace :populate_codetable38 do
	desc "Add_Approval Disposition Reason"
	task :add_Approve_disposition_reason => :environment do
		CodetableItem.create(code_table_id:66,short_description:"Approved",long_description:" ",system_defined:"FALSE",active:"TRUE")
		CodetableItem.where("code_table_id = 132 and id = 6040").destroy_all
		CodetableItem.where("code_table_id = 132 and id = 6042").update_all(short_description:"Approved", long_description:"")
		CodetableItem.where("code_table_id = 132 and id = 6041").update_all(short_description:"Denied", long_description:"")

		# cleanup Relationship data.
		# relation = spouse-legal ceremony changed to "spouse"
		CodetableItem.where("code_table_id = 125 and id = 5991").update_all(short_description:"Spouse", long_description:"")
		# relation= Spouse - Common Law  deleted.
		CodetableItem.where("code_table_id = 125 and id = 5990").destroy_all
		# 5977 = Parent is retained .
		# 5956 = Parent- Biological - deleted
        # 5957 = Parent- Legal - deleted
        # 6003 = Step Parent- deleted
        # 6013 = step child -  deleted
        CodetableItem.where("code_table_id = 125 and id = 5956").destroy_all
        CodetableItem.where("code_table_id = 125 and id = 5957").destroy_all
        CodetableItem.where("code_table_id = 125 and id = 6003").destroy_all
        CodetableItem.where("code_table_id = 125 and id = 6013").destroy_all
  #       6010;125;"Child-Legal"
		# 5948;125;"Child - Adoptive"
		# 5949;125;"Child - Biological"
		# 5951;125;"Child - Foster"
		# 5952;125;"Child - In common"
		# 5953;125;"Child - Step"
		 CodetableItem.where("code_table_id = 125 and id = 6010").destroy_all
		 CodetableItem.where("code_table_id = 125 and id = 5948").destroy_all
		 CodetableItem.where("code_table_id = 125 and id = 5949").destroy_all
		 CodetableItem.where("code_table_id = 125 and id = 5951").destroy_all
		 CodetableItem.where("code_table_id = 125 and id = 5952").destroy_all
		 CodetableItem.where("code_table_id = 125 and id = 5953").destroy_all
		#  5992	Step Aunt/Uncle
		# 6013	Step Child
		# 5993	Step First Cousin
		# 5996	Step Gr Gr Gr Grandchild
		# 6011	Step Gr Gr Gr Grandparent
		# 5997	Step Grandchild
		# 5998	Step Grandparent
		# 6000	Step Great Grandchild
		# 6012	Step Great Grandparent
		# 6002	Step Niece/Nephew
		# 6003	Step Parent
		# 6006	Step Sibling
		CodetableItem.where("code_table_id = 125 and id = 5992").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 6013").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5993").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5996").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 6011").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5997").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5998").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 6000").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 6012").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 6002").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 6003").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 6006").destroy_all


	end
end