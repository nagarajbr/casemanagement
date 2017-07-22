#encoding: utf-8
namespace :expected_work_participation_hours_task do
	desc "Expected Work Participation Hours"
	task :populate_expected_work_participation_hours => :environment do
		 connection = ActiveRecord::Base.connection()
    	 connection.execute("TRUNCATE TABLE public.expected_work_participation_hours")
    	 connection.execute("SELECT setval('public.expected_work_participation_hours_id_seq', 1, true)")
         # TEA expected work particiption hours for case types - single parent,Two Parent,Minor Parent
		 ExpectedWorkParticipationHour.create(service_program_id: 1,
                                              case_type: 6046,
                                              work_participation_mandatory_deferred: "Mandatory",
                                              work_participation_condition: "No child under 6 years of age",
                                              min_core_hours: 20,
                                              non_core_hours: 10,
                                              comments: "All hours can be core activities",
                                              created_by:19,
                                              updated_by:19
                                              )

          ExpectedWorkParticipationHour.create(service_program_id: 1,
                                              case_type: 6046,
                                              work_participation_mandatory_deferred: "Mandatory",
                                              work_participation_condition: "One or more children under 6 years of age",
                                              min_core_hours: 20,
                                              non_core_hours: 0,
                                              comments: "All hours can be core activities",
                                              created_by:19,
                                              updated_by:19
                                              )

           ExpectedWorkParticipationHour.create(service_program_id: 1,
                                              case_type: 6046,
                                              work_participation_mandatory_deferred: "Deferred",
                                              work_participation_condition: "NA",
                                              min_core_hours: 0,
                                              non_core_hours: 0,
                                              comments: "Not required to participate in work activities",
                                              created_by:19,
                                              updated_by:19
                                              )

            ExpectedWorkParticipationHour.create(service_program_id: 1,
                                              case_type: 6047,
                                              work_participation_mandatory_deferred: "Mandatory",
                                              work_participation_condition: "No child care",
                                              min_core_hours: 30,
                                              non_core_hours: 5,
                                              comments: "All hours can be core activities",
                                              created_by:19,
                                              updated_by:19
                                              )

              ExpectedWorkParticipationHour.create(service_program_id: 1,
                                              case_type: 6047,
                                              work_participation_mandatory_deferred: "Mandatory",
                                              work_participation_condition: "Child care provided",
                                              min_core_hours: 50,
                                              non_core_hours: 5,
                                              comments: "All hours can be core activities",
                                              created_by:19,
                                              updated_by:19
                                              )
          ExpectedWorkParticipationHour.create(service_program_id: 1,
                                              case_type: 6047,
                                              work_participation_mandatory_deferred: "Mandatory",
                                              work_participation_condition: "One parent disabled",
                                              min_core_hours: 30,
                                              non_core_hours: 0,
                                              comments: "All hours can be core activities",
                                              created_by:19,
                                              updated_by:19
                                              )
          ExpectedWorkParticipationHour.create(service_program_id: 1,
                                              case_type: 6047,
                                              work_participation_mandatory_deferred: "Mandatory",
                                              work_participation_condition: "One parent deferred",
                                              min_core_hours: 30,
                                              non_core_hours: 5,
                                              comments: "All hours can be core activities",
                                              created_by:19,
                                              updated_by:19
                                              )

          ExpectedWorkParticipationHour.create(service_program_id: 1,
                              case_type: 6047,
                              work_participation_mandatory_deferred: "Deferred",
                              work_participation_condition: "NA",
                              min_core_hours: 0,
                              non_core_hours: 0,
                              comments: "Not required to participate in work activities",
                              created_by:19,
                              updated_by:19
                              )

           ExpectedWorkParticipationHour.create(service_program_id: 1,
                              case_type: 6049,
                              work_participation_mandatory_deferred: "Mandatory",
                              work_participation_condition: "NA",
                              min_core_hours: 0,
                              non_core_hours: 20,
                              comments: "All hours should be against High school diploma or GED",
                              created_by:19,
                              updated_by:19
                              )

             ExpectedWorkParticipationHour.create(service_program_id: 1,
                              case_type: 6049,
                              work_participation_mandatory_deferred: "Deferred",
                              work_participation_condition: "NA",
                              min_core_hours: 0,
                              non_core_hours: 0,
                              comments: "Not required to participate in work activities",
                              created_by:19,
                              updated_by:19
                              )

          # WORKPAYS expected work particiption hours for case types - single parent,Two Parent,Minor Parent
         ExpectedWorkParticipationHour.create(service_program_id: 4,
                                              case_type: 6046,
                                              work_participation_mandatory_deferred: "Mandatory",
                                              work_participation_condition: "No child under 6 years of age",
                                              min_core_hours: 6,
                                              non_core_hours: 0,
                                              workpays_min_employment_hours: 24,
                                              comments: "",
                                              created_by:19,
                                              updated_by:19
                                              )

          ExpectedWorkParticipationHour.create(service_program_id: 4,
                                              case_type: 6046,
                                              work_participation_mandatory_deferred: "Mandatory",
                                              work_participation_condition: "One or more children under 6 years of age",
                                              min_core_hours: 0,
                                              non_core_hours: 0,
                                              workpays_min_employment_hours: 24,
                                              comments: "",
                                              created_by:19,
                                              updated_by:19
                                              )

           ExpectedWorkParticipationHour.create(service_program_id: 4,
                                              case_type: 6047,
                                              work_participation_mandatory_deferred: "Mandatory",
                                              work_participation_condition: "No child care",
                                              min_core_hours: 6,
                                              non_core_hours: 5,
                                              workpays_min_employment_hours: 24,
                                              comments: "All hours can be core activities. 24 hours can be combined for both parents or either parents",
                                              created_by:19,
                                              updated_by:19
                                              )

            ExpectedWorkParticipationHour.create(service_program_id: 4,
                                              case_type: 6047,
                                              work_participation_mandatory_deferred: "Mandatory",
                                              work_participation_condition: "Child care provided",
                                              min_core_hours: 26,
                                              non_core_hours: 5,
                                              workpays_min_employment_hours: 24,
                                              comments: "All hours can be core activities. 24 hours can be combined for both parents or either parents",
                                              created_by:19,
                                              updated_by:19
                                              )


    end
end