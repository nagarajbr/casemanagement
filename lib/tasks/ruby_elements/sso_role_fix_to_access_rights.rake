namespace :sso_permission_access_rights_update do
	desc "sso_permission_access_rights_update"
	task :sso_permission_access_rights_update => :environment do

		# Permission - Specialist(3) is mapped to role - 3,4,7,9,10,11

		# manager = 6 is mapped to role id 6,12,13 (6 - manager,12-"Compliance Officer",13- "Finance Officer")
		AccessRight.where("role_id in (12,13)
						  and ruby_element_id not in (select ruby_element_id
						  	                          from access_rights
						  	                          where  role_id = 6
						  	                          )
						").update_all(role_id: 6)

		AccessRight.where("role_id in (12,13)").destroy_all

		# 2.
		AccessRight.where("role_id in (8)").destroy_all
		# 3.
		AccessRight.where("role_id in (4,7,9,10,11)").destroy_all
		# 4. Manager is above supervisor - he can do all what supervisor does.
		collection = AccessRight.where("role_id = 6 and ruby_element_id = 811")
		if collection.blank?
			object = AccessRight.new
			object.role_id = 6
			object.ruby_element_id = 811
			object.access = 'Y'
			object.save
		end

		collection = AccessRight.where("role_id = 6 and ruby_element_id = 812")
		if collection.blank?
			object = AccessRight.new
			object.role_id = 6
			object.ruby_element_id = 812
			object.access = 'Y'
			object.save
		end

		collection = AccessRight.where("role_id = 6 and ruby_element_id = 813")
		if collection.blank?
			object = AccessRight.new
			object.role_id = 6
			object.ruby_element_id = 813
			object.access = 'Y'
			object.save
		end

		collection = AccessRight.where("role_id = 6 and ruby_element_id = 819")
		if collection.blank?
			object = AccessRight.new
			object.role_id = 6
			object.ruby_element_id = 819
			object.access = 'Y'
			object.save
		end

		collection = AccessRight.where("role_id = 6 and ruby_element_id = 820")
		if collection.blank?
			object = AccessRight.new
			object.role_id = 6
			object.ruby_element_id = 820
			object.access = 'Y'
			object.save
		end



		AccessRight.where("ruby_element_id in (select id from ruby_elements
						    where element_name like '%assessment%' )
						  and role_id = 3").update_all(access: 'Y')

		AccessRight.where("ruby_element_id in (select id from ruby_elements
						    where element_name like '%ction_plan%' )
						  and role_id = 3").update_all(access: 'Y')
		AccessRight.where("ruby_element_id = 145
						  and role_id = 3").update_all(access: 'Y')

		# manager should have access to utilities management - start
		collection = AccessRight.where("role_id = 6 and ruby_element_id = 190")
		if collection.blank?
			object = AccessRight.new
			object.role_id = 6
			object.ruby_element_id = 190
			object.access = 'Y'
			object.save
		else
			object = collection.first
			object.access = 'Y'
			object.save
		end
		# Supervisor should have access to utilities management
		collection = AccessRight.where("role_id = 5 and ruby_element_id = 190")
		if collection.blank?
			object = AccessRight.new
			object.role_id = 5
			object.ruby_element_id = 190
			object.access = 'Y'
			object.save
		end

		ruby_element_collection = RubyElementReltn.where("parent_element_id = 190")
		if ruby_element_collection.present?
			# manager should have access to utilitities management child menu items
			ruby_element_collection.each do |each_element|
				access_collection = AccessRight.where("role_id = 6 and ruby_element_id = ?",each_element.child_element_id)
				if access_collection.blank?
					object = AccessRight.new
					object.role_id = 6
					object.ruby_element_id = each_element.child_element_id
					object.access = 'Y'
					object.save
				else
					object = access_collection.first
					object.access = 'Y'
					object.save
				end
				ruby_level3_collection = RubyElementReltn.where("parent_element_id = ?",each_element.child_element_id)
				ruby_level3_collection.each do |level3_element|
					access_collection3 = AccessRight.where("role_id = 6 and ruby_element_id = ?",level3_element.child_element_id)
					if access_collection3.blank?
						object = AccessRight.new
						object.role_id = 6
						object.ruby_element_id = each_element.child_element_id
						object.access = 'Y'
						object.save
					else
						object = access_collection3.first
						object.access = 'Y'
						object.save
					end
				end

			end
			# supervisor should have access to utilitities management child menu items
			ruby_element_collection.each do |each_element|
				access_collection = AccessRight.where("role_id = 5 and ruby_element_id = ?",each_element.child_element_id)
				if access_collection.blank?
					object = AccessRight.new
					object.role_id = 5
					object.ruby_element_id = each_element.child_element_id
					object.access = 'Y'
					object.save
				else
					object = access_collection.first
					object.access = 'Y'
					object.save

				end

				ruby_level3_collection = RubyElementReltn.where("parent_element_id = ?",each_element.child_element_id)
				ruby_level3_collection.each do |level3_element|
					access_collection3 = AccessRight.where("role_id = 5 and ruby_element_id = ?",level3_element.child_element_id)
					if access_collection3.blank?
						object = AccessRight.new
						object.role_id = 5
						object.ruby_element_id = each_element.child_element_id
						object.access = 'Y'
						object.save
					else
						object = access_collection3.first
						object.access = 'Y'
						object.save
					end
				end
			end
		end # end of utility

		# disable user menus
		AccessRight.where("ruby_element_id in (193,
												194,
												195,
												196,
												204)
		                 ").update_all(access:'N')

		# cpp and education scores to specialist
			AccessRight.where("ruby_element_id in (206,207,50,51,728,85)
				            ").update_all(access:'Y')

		# all should be able submit payment
		AccessRight.where("ruby_element_id in (681,683,684)
				            ").update_all(access:'Y')

		# all should be able submit payment
		AccessRight.where("ruby_element_id in (139)
				            ").update_all(access:'N')


	end
end