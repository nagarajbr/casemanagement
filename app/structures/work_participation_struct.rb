class WorkParticipationStruct
	attr_accessor :week_ending, :core_hours, :non_core_hours, :total_hours, :reporting_date, :work_characteristics, :schedule_result,
				  :reporting_month_core_hrs, :reporting_month_non_core_hrs, :reporting_month_total_hrs,
				  :total_hrs_required, :core_hrs_required, :total_hrs_required_per_week, :core_hrs_required_per_week,
				  :required_avg_hrs_per_week, :required_core_avg_hrs_per_week, :reported_avg_hrs_per_week, :reported_core_avg_hrs_per_week, :reported_non_core_avg_hrs_per_week
	def initialize
		@work_characteristics = {}
	end
end