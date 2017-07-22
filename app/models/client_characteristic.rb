class ClientCharacteristic < ActiveRecord::Base
    has_paper_trail :class_name => 'ClientCharacteristicVersion',:on => [:update, :destroy]

    # virtual fields of household member yes/no/skip fields
    attr_accessor :client_general_health_chalng_to_work_charcteristics_found_add_flag

    include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field
    belongs_to :characteristic, polymorphic: true
    belongs_to :client
    #Model Validations
    validates_presence_of :client_id, :start_date, :characteristic_id,message: "is required."
    validate :start_date_less_than_end_date?, :ipv_validations, :validate_short_term_disability
    validates_uniqueness_of :characteristic_id, scope: [:client_id],
    conditions: -> {where("characteristic_id = 5614 or characteristic_id = 6331")}, message: " already applied."

    def start_date_less_than_end_date?
        if start_date.present?
            if end_date.present? && self.characteristic_id != 6332
                if start_date > end_date
                    errors[:base] << "End date should be greater than start date."
                    return false
                else
                    return true
                end
            else
                return true
            end
        else
            return false
        end
    end


    def set_create_user_fields
        user_id = AuditModule.get_current_user.uid
        self.created_by = user_id
        self.updated_by = user_id
    end

    def set_update_user_field
        user_id = AuditModule.get_current_user.uid
        self.updated_by = user_id
    end

    def self.retrieve_characteristics(arg_client_id,arg_char_type)
        where("client_id=? and characteristic_type=?",arg_client_id,arg_char_type).order("updated_at DESC")
    end

    def self.has_work_registartion(arg_client_id, arg_date)
        where("client_id =? and characteristic_type = 'WorkCharacteristic'
            and ((? between date_trunc('month', start_date) and date_trunc('month', end_date)+'1month'::interval-'1day'::interval) or (date_trunc('month', start_date) <= ? and end_date is null))",arg_client_id, arg_date, arg_date).count > 0
    end

    def self.has_valid_other_characteristic(arg_client_id, arg_date)
        result = true
        char_type_no_school_attd = get_no_school_attendance_characteristic_id(arg_client_id)
        other_characteristics = where("client_id =? and (characteristic_type = 'OtherCharacteristic' or characteristic_type = 'LegalCharacteristic')",arg_client_id)
        if other_characteristics.present?
            if other_characteristics.where("characteristic_id in (5611, 5612, 5614, 5638, 5641, 5610, 5616, 6331, 6332,?) and
                ((? between date_trunc('month', start_date) and date_trunc('month', end_date)+'1month'::interval-'1day'::interval) or (date_trunc('month', start_date) <= ? and end_date is null))",char_type_no_school_attd, arg_date, arg_date).count > 0
                result = false
            end
        end
        return result
    end

    def self.get_violated_other_characteristics(arg_client_id)
        char_type_no_school_attd = get_no_school_attendance_characteristic_id(arg_client_id)
        where("client_id =? and characteristic_id in (5611, 5612, 5614, 5638, 5641, 5610, 5616, 6331, 6332, ?)",arg_client_id, char_type_no_school_attd)
    end

    def self.get_violated_other_characteristics_ed(arg_client_id, arg_date)
        char_type_no_school_attd = get_no_school_attendance_characteristic_id(arg_client_id)
        where("client_id =? and characteristic_id in (5611, 5612, 5614, 5638, 5641, 5610, 5616, 6331, 6332, ?) and
                ((? between date_trunc('month', start_date) and date_trunc('month', end_date)+'1month'::interval-'1day'::interval) or (date_trunc('month', start_date) <= ? and end_date is null))",arg_client_id, char_type_no_school_attd, arg_date, arg_date)
    end

    def self.get_current_work_characteristics(arg_client_id,arg_date)
        result = ""
        step1 = where("client_id =?
                       and characteristic_type = 'WorkCharacteristic'
                       and ((? between date_trunc('month', start_date)
                                and date_trunc('month', end_date)+'1month'::interval-'1day'::interval)
                            or (date_trunc('month', start_date) <= ?
                                and end_date is null))
                       ",arg_client_id,arg_date,arg_date )

        if step1.present?
            deffered_charateristic_present = step1.where.not(characteristic_id: 5667)
            if deffered_charateristic_present.count > 0
               result = deffered_charateristic_present.first.characteristic_id
            else
               result =  step1.first.characteristic_id
            end
        end
        return result
    end

    def self.does_client_has_eligible_work_characteristics_to_avoid_time_limits_validations(arg_client_id)
        where("client_id =? and characteristic_type = 'WorkCharacteristic' and characteristic_id in (5720, 5662, 5664, 5719, 5721, 5668)",arg_client_id).count > 0
    end

      def self.has_valid_minor_parent_work_registartion(arg_client_id,arg_date)
        work_characteristics_collection = where("client_id =?
                and characteristic_type = 'WorkCharacteristic'
                and characteristic_id in (5674, 5700, 5701)
                and ((? between date_trunc('month', start_date)
                                and date_trunc('month', end_date)+'1month'::interval-'1day'::interval)
                            or (date_trunc('month', start_date) <= ?
                                and end_date is null))",arg_client_id,arg_date,arg_date)
        if work_characteristics_collection.count > 0
            return true
        else
            return false
        end
    end

      def self.has_valid_minor_parent_work_registartion_without_date(arg_client_id)
          work_characteristics_collection = where("client_id =?
                and characteristic_type = 'WorkCharacteristic'
                and characteristic_id in (5674, 5700, 5701)
               ",arg_client_id)
         if work_characteristics_collection.count > 0
            return true
         else
            return false
         end
    end

    def self.get_all_the_records_with_same_characteristic_id_for_the_client(arg_characteristic_id, arg_client_id)
        where("characteristic_id = ? and client_id = ?",arg_characteristic_id, arg_client_id).order("end_date desc")
    end

    def self.get_all_work_characteristic_records_for_the_client(arg_client_id)
         where("characteristic_type = 'WorkCharacteristic' and client_id = ?",arg_client_id).order("end_date desc")
    end

    def is_there_a_record_with_same_characteristic_type_and_open_end_date(arg_characteristic_id, arg_client_id)
        if self.id.present?
            ClientCharacteristic.where("characteristic_id = ? and client_id = ? and end_date is null and id != ?",arg_characteristic_id, arg_client_id, self.id).count > 0
        else
            ClientCharacteristic.where("characteristic_id = ? and client_id = ? and end_date is null",arg_characteristic_id, arg_client_id).count > 0
        end
    end

    def is_there_a_record_with_work_characteristic_type_and_open_end_date(arg_characteristic_type, arg_client_id)
        if self.id.present?
            ClientCharacteristic.where("characteristic_type = ? and client_id = ? and end_date is null and id != ?",arg_characteristic_type, arg_client_id,self.id).count > 0
        else
            ClientCharacteristic.where("characteristic_type = ? and client_id = ? and end_date is null",arg_characteristic_type, arg_client_id).count > 0
        end
    end

    def self.get_work_characteristic_for_client(arg_client_id)
        where("client_id =? and characteristic_type = 'WorkCharacteristic'",arg_client_id)
    end

    def self.has_disability_ssi_characteristic(arg_client_id, arg_date)
        return where("client_id =? and characteristic_type = 'DisabilityCharacteristic' and characteristic_id = 5731 and
            ((? between date_trunc('month', start_date) and date_trunc('month', end_date)+'1month'::interval-'1day'::interval) or (date_trunc('month', start_date) <= ? and end_date is null))",arg_client_id, arg_date, arg_date).count > 0
    end

    def ipv_validations
        if self.characteristic_id == 5614 #IPV 1
            if self.start_date.present? && self.start_date == Date.today.at_beginning_of_month.next_month
                if self.end_date.present?
                    if self.end_date != (self.start_date + 1.year - 1)
                        errors[:end_date] << "is required and should be #{(self.start_date + 1.year - 1).strftime("%m/%d/%Y")} for #{CodetableItem.get_short_description(5614)}"
                    end
                else
                    errors[:end_date] << "is required and should be #{(self.start_date + 1.year - 1).strftime("%m/%d/%Y")} for #{CodetableItem.get_short_description(5614)}"
                end
            else
                errors[:start_date] << "is required and should be #{Date.today.at_beginning_of_month.next_month.strftime("%m/%d/%Y")}"
            end

        elsif self.characteristic_id == 6331 #IPV2
            ipv1 = ClientCharacteristic.where("characteristic_id = 5614 and client_id = ?", self.client_id)
            if ipv1.count == 1
                if self.start_date.present? && self.start_date == Date.today.at_beginning_of_month.next_month
                    if self.start_date > ipv1.first.end_date
                        if self.start_date == Date.today.at_beginning_of_month.next_month
                            if self.end_date.present?
                                if self.end_date != (self.start_date + 2.year - 1)
                                    errors[:end_date] << "is required and should be #{(self.start_date + 2.year - 1).strftime("%m/%d/%Y")} for #{CodetableItem.get_short_description(6331)}"
                                end
                            else
                                errors[:end_date] << "is required and should be #{(self.start_date + 2.year - 1).strftime("%m/%d/%Y")} for #{CodetableItem.get_short_description(6331)}"
                            end
                        end
                    else
                        errors[:start_date] << "should be greater than #{CodetableItem.get_short_description(5614)} end date #{ipv1.first.end_date.strftime("%m/%d/%Y")}"
                    end

                else
                    errors[:start_date] << "is required and should be #{Date.today.at_beginning_of_month.next_month.strftime("%m/%d/%Y")}"
                end
            else
                errors[:base] << "IPV1 violation was not applied, cannot apply IPV2 at this time"
            end
        elsif self.characteristic_id == 6332 #IPV3
            number_of_violations_added = ClientCharacteristic.where("characteristic_id in (5614, 6331) and client_id = ?", self.client_id).count
            if number_of_violations_added == 2
                if self.start_date.present? && self.start_date == Date.today.at_beginning_of_month.next_month
                    ipv2 = ClientCharacteristic.where("characteristic_id = 6331 and client_id = ?", self.client_id)
                    ipv2 = ipv2.first
                    if self.start_date > ipv2.end_date
                        if self.start_date == Date.today.at_beginning_of_month.next_month
                            if self.end_date.present?
                                errors[:end_date] << " cannot be applied for #{CodetableItem.get_short_description(6332)}"
                            end
                        else
                            errors[:start_date] << "is required and should be #{Date.today.at_beginning_of_month.next_month.strftime("%m/%d/%Y")}"
                        end
                    else
                        errors[:start_date] << "should be greater than #{CodetableItem.get_short_description(6331)} end date #{ipv2.end_date.strftime("%m/%d/%Y")}"
                    end
                else
                    errors[:start_date] << "is required and should be #{Date.today.at_beginning_of_month.next_month.strftime("%m/%d/%Y")}"
                end
            else
                if number_of_violations_added == 0
                    errors[:base] << "IPV1 & IPV2 violations were not applied, cannot apply IPV3 at this time"
                else
                    errors[:base] << "IPV2 violation was not applied, cannot apply IPV3 at this time"
                end

            end
        end
    end

    def validate_short_term_disability
        if self.characteristic_id == 5666
            if self.end_date.blank?
                errors[:base] << "End date is required for short term disability and not more than #{(self.start_date+3.months).strftime("%m/%d/%Y")}."
            elsif self.end_date > self.start_date+3.months
                errors[:base] << "End date for short term disability should not be more than #{(self.start_date+3.months).strftime("%m/%d/%Y")}."
            end
        end
    end



    # Manoj Patil 03/19/2015
    # CPP is needed only for members with Open - mandatory work participation characterists.
    def self.is_open_client_mandatory_work_caharacteric_present?(arg_client_id)
        lb_return = false
        ldt_date_of_pgu_activation = Date.today
        open_mandatory_work_participations_collection = ClientCharacteristic.where("client_id = ?
                                                                                    and characteristic_id in (select CAST( value AS integer)
                                                                                                              from system_params
                                                                                                              where system_param_categories_id = 9
                                                                                                              and key = 'CPP_WORK_CHARACTERISTICS')
                                                                                                              and (end_date is null or end_date > ?)
                                                                                                              ",arg_client_id,ldt_date_of_pgu_activation
                                                                                                              )
        if open_mandatory_work_participations_collection.present?
            lb_return =  true
        end
        return lb_return

    end

    def self.are_there_any_eligible_work_characteristics_to_skip_state_time_limits_validation(arg_client_id, arg_date)
        where("client_id =? and characteristic_type = 'WorkCharacteristic' and
                characteristic_id in (select CAST(nullif(value, '') AS integer) from system_params where system_param_categories_id = 9 and key = 'TEA_EXTN_DEFERRALS')
                and ((? between date_trunc('month', start_date) and date_trunc('month', end_date)+'1month'::interval-'1day'::interval) or (date_trunc('month', start_date) <= ? and end_date is null))",arg_client_id, arg_date, arg_date).count > 0
    end

    def self.open_mandatory_work_characteristic_found?(arg_client_id, arg_date)
        ldt_today = Date.today
        mandatory_work_char_collection = where("client_id =? and characteristic_id = 5667 and
                                                ((? between date_trunc('month', start_date) and date_trunc('month', end_date)+'1month'::interval-'1day'::interval) or
                                                    (date_trunc('month', start_date) <= ? and end_date is null))",arg_client_id,arg_date, arg_date)
        if mandatory_work_char_collection.present?
            return true
        else
            return false
        end
    end



    def self.work_participation_characters_for_elible_program_unit(arg_program_unit_id)
        step1 = ProgramUnit.joins("INNER JOIN program_wizards
                                   ON program_units.id = program_wizards.program_unit_id
                                  INNER JOIN program_benefit_members
                                  ON  (program_wizards.id = program_benefit_members.program_wizard_id
                                       AND program_benefit_members.member_status = 4468
                                       )
                                  INNER JOIN client_characteristics
                                  ON (client_characteristics.CLIENT_ID = program_benefit_members.client_id
                                      and client_characteristics.characteristic_id in (select CAST( value AS integer)
                                                                                       from system_params
                                                                                       where system_param_categories_id = 9
                                                                                       and key = 'CPP_WORK_CHARACTERISTICS'
                                                                                       )
                                      and (end_date is null or end_date > current_date)
                                      )
                                  INNER JOIN clients
                                  ON clients.id = client_characteristics.CLIENT_ID
                                  INNER JOIN codetable_items characteristic_types
                                  ON characteristic_types.id = client_characteristics.characteristic_id "
                                  )
        step2 = step1.where("program_units.ID = ?",arg_program_unit_id)
        step3 = step2.select("CLIENTS.LAST_NAME,
                              CLIENTS.FIRST_NAME,
                              CLIENTS.ID as client_id,
                              characteristic_types.SHORT_DESCRIPTION as wp_character"
                              )
        wp_collection = step3
        return wp_collection
    end

    def self.get_no_school_attendance_characteristic_id(arg_client_id)
        # No school attendance validation should be performed only for kids
        # It is considered as an other characteristic violation
        # This mathod returns characteristic id for kids and zero for adults

        char_type_no_school_attd = 0
        client_age = Client.is_adult(arg_client_id)
        if client_age == false
            # Rails.logger.debug("client_age = #{client_age.inspect}")
            char_type_no_school_attd = 6541
        end
    end

    def self.populate_client_characteristic_information(arg_client_id, arg_characteristic_id, arg_characteristic_type, arg_start_date, arg_end_date)
        client_characteristic = new
        client_characteristic.client_id = arg_client_id
        client_characteristic.characteristic_id = arg_characteristic_id
        client_characteristic.characteristic_type = arg_characteristic_type
        client_characteristic.start_date = arg_start_date
        client_characteristic.end_date = arg_end_date if arg_end_date.present?
        return client_characteristic
    end

    # def self.delete_characteristic_for_client(arg_client_id, arg_characteristic_id, arg_characteristic_type)

    # end

    def self.has_felon_characteristic(arg_client_id)
        where("client_id = ? and (characteristic_id = 5611 or characteristic_id = 5612) and (end_date is null or current_date between start_date and end_date)",arg_client_id).count > 0
    end

    def self.open_characteristics_for_client(arg_characteristic_type,arg_client_id)
       where("client_id = ? and characteristic_type = ? and (end_date is null or current_date between start_date and end_date)",arg_client_id,arg_characteristic_type)
    end

    def self.get_work_participation_for_parent(arg_parent_id, arg_start_date, arg_end_date)
        # Return the work participation mandatory characteristics if one exists else return the first available deferred characteristics
        # If no manadatory or deferred work participation exists for the parent, default it to "Required to Work"
        # 5667 - "Required to work"
        # 5700 - "TEA Minor Parent BU Head"
        # 5701 - "TEA Minor Parent School"
        work_participation_characteristic_id = 5667
        result = where("client_id = ? and characteristic_id in (5667,5700,5701)
                        and ((start_date <= ? and end_date is null)
                             or (start_date <= ? and (end_date is not null and end_date >= ?))
                             or (start_date between ?  and ? and end_date between ?  and ?)
                            )
                       ",arg_parent_id, arg_end_date, arg_start_date, arg_start_date, arg_start_date, arg_end_date, arg_start_date, arg_end_date
                       ).order(:start_date)
        if result.present?
            work_participation_characteristic_id = result.first.characteristic_id
        else
            step1 = joins("INNER JOIN codetable_items ON client_characteristics.characteristic_id = codetable_items.id")
            step2 = step1.where("codetable_items.code_table_id = 113 and codetable_items.active = 't'")
            result = step2.where("client_characteristics.client_id = ? and client_characteristics.characteristic_id not in (5667,5700,5701)
                                   and ((client_characteristics.start_date <= ? and client_characteristics.end_date is null)
                                         or (client_characteristics.start_date <= ? and (client_characteristics.end_date is not null and client_characteristics.end_date >= ?))
                                         or (client_characteristics.start_date between ?  and ? and (client_characteristics.end_date is null or client_characteristics.end_date >= ?))
                                       )
                                 ",arg_parent_id, arg_end_date, arg_start_date, arg_start_date, arg_start_date, arg_end_date, arg_start_date
                                ).order(:start_date)
            work_participation_characteristic_id = result.first.characteristic_id if result.present?
        end
        return work_participation_characteristic_id
    end

    def self.has_a_deferred_work_characteristic_on_the_given_date(arg_client_id, arg_date)
        # All work characteristics other than mandatory work characteristics is considered to be deferred.
        step1 = joins("INNER JOIN codetable_items ON codetable_items.code_table_id = 113
                       and codetable_items.id not in (5667,5700,5701,5661,5662,5663,5665,5666,5680,5714,5722,5723)
                       and client_characteristics.characteristic_id = codetable_items.id")
        result = step1.where("client_id = ?
                     and characteristic_type = 'WorkCharacteristic'
                     and ((start_date < ? and end_date is null) or (? between start_date and end_date))",arg_client_id, arg_date, arg_date).present?
        # Rails.logger.debug("has_a_deferred_work_characteristic_on_the_given_date - #{arg_client_id} - #{result}")
        return result
    end

    def self.has_a_deferred_work_characteristic_in_a_given_date_range(arg_client_id, arg_start_date, arg_end_date)
        step1 = joins("INNER JOIN codetable_items ON codetable_items.code_table_id = 113
                       and codetable_items.id not in (5667,5700,5701,5661,5662,5663,5665,5666,5680,5714,5722,5723)
                       and client_characteristics.characteristic_id = codetable_items.id")
        result = step1.where("client_id = ? and start_date <= ?
                              and (end_date is null or end_date >= ?)",arg_client_id, arg_start_date, arg_end_date).present?
        # Rails.logger.debug("has_a_deferred_work_characteristic_in_a_given_date_range - #{arg_client_id} - #{result}")
        return result
    end

    def self.get_deferred_characteristic_records(arg_client_id, arg_end_date)
        step1 = joins("INNER JOIN codetable_items ON codetable_items.code_table_id = 113
                       and codetable_items.id not in (5667,5700,5701,5661,5662,5663,5665,5666,5680,5714,5722,5723)
                       and client_characteristics.characteristic_id = codetable_items.id")
        result = step1.where("client_id = ? and start_date <= ?", arg_client_id,arg_end_date).order(:start_date)
    end

    def self.has_a_disabled_work_characteristic_in_a_given_date_range(arg_client_id, arg_start_date, arg_end_date)
        step1 = joins("INNER JOIN codetable_items ON codetable_items.code_table_id = 113 and codetable_items.id in (5661,5662,5663,5665,5666,5680,5714,5722,5723)
                    and client_characteristics.characteristic_id = codetable_items.id")
        result = step1.where("client_id = ? and start_date <= ? and (end_date is null or end_date >= ?)",arg_client_id, arg_start_date, arg_end_date).present?
        # Rails.logger.debug("has_a_disabled_work_characteristic_in_a_given_date_range - #{arg_client_id} - #{result}")
        return result
    end

    def self.get_disabled_work_characteristic_records(arg_client_id, arg_end_date)
        step1 = joins("INNER JOIN codetable_items ON codetable_items.code_table_id = 113 and codetable_items.id in (5661,5662,5663,5665,5666,5680,5714,5722,5723)
                       and client_characteristics.characteristic_id = codetable_items.id")
        step1.where("client_id = ? and start_date <= ?", arg_client_id,arg_end_date).order(:start_date)
    end

    # def self.has_mandatory_work_characteristic_in_a_given_date_range(arg_client_id, arg_start_date, arg_end_date)
    #     step1 = joins("INNER JOIN codetable_items ON codetable_items.code_table_id = 113 and codetable_items.id in (5667,5700,5701)
    #                    and client_characteristics.characteristic_id = codetable_items.id")
    #     result = step1.where("client_id = ? and ((start_date <= ? and (end_date is null or end_date >= ?))
    #                                      or (start_date between ?  and ? and (end_date is null or end_date >= ?))
    #                                    )",arg_client_id, arg_start_date, arg_start_date, arg_start_date, arg_end_date, arg_start_date).present?
    #     Rails.logger.debug("has_mandatory_work_characteristic_in_a_given_date_range - #{arg_client_id} - #{result}")
    #     return result
    # end

    def self.has_mandatory_work_characteristic_in_a_given_date_range(arg_client_id, arg_start_date, arg_end_date)
        step1 = joins("INNER JOIN codetable_items ON codetable_items.code_table_id = 113 and codetable_items.id in (5667,5700,5701)
                       and client_characteristics.characteristic_id = codetable_items.id")
        result = step1.where("client_id = ? and start_date <= ? and (end_date is null or end_date >= ?)",arg_client_id, arg_start_date, arg_end_date).present?
        # Rails.logger.debug("has_mandatory_work_characteristic_in_a_given_date_range - #{arg_client_id} - #{result}")
        return result
    end
end