module AuditTrailModule
	def self.get_audit_mstr(arg_run_id, arg_month_id, arg_member_id, arg_details_id)

		lds_audit_trail_income_details = AuditTrailMaster.get_audit_trail_master_details_by_client(arg_run_id,arg_month_id,arg_member_id,arg_details_id)

			lstr_pass_ret = []
		if lds_audit_trail_income_details.present?

           lds_audit_trail_income_details.each do |audit_trail_income_details|
           	lstr_pass_ret[1] = audit_trail_income_details.run_id
			lstr_pass_ret[2] = audit_trail_income_details.month_sequence
			lstr_pass_ret[3] = audit_trail_income_details.member_sequence
			lstr_pass_ret[4] = audit_trail_income_details.b_details_sequence
			lstr_pass_ret[5] = audit_trail_income_details.id
			lstr_pass_ret[6] = audit_trail_income_details.client_id
			lstr_pass_ret[7] = audit_trail_income_details.service_program_id
			lstr_pass_ret[8] = audit_trail_income_details.intended_use_mos
			lstr_pass_ret[9] = audit_trail_income_details.contract_amt

			lstr_pass_ret[10] = audit_trail_income_details.source  #s[1]
			lstr_pass_ret[11] = audit_trail_income_details.created_by #s[2]
			lstr_pass_ret[12] = audit_trail_income_details.processing_location #s[3]
			lstr_pass_ret[13] = audit_trail_income_details.frequency #s[4]
			lstr_pass_ret[14] = audit_trail_income_details.inc_exp_type #s[5]
			lstr_pass_ret[15] = audit_trail_income_details.audit_det_ind #s[6]

			lstr_pass_ret[16] = audit_trail_income_details.created_at #dt[1]
			lstr_pass_ret[17] = audit_trail_income_details.inc_avg_begin_date #dt[2]
			lstr_pass_ret[18] = audit_trail_income_details.effective_beg_date #dt[3]
			lstr_pass_ret[19] = audit_trail_income_details.effective_end_date #dt[4]


            end
		end

	 return lstr_pass_ret
	end



 def self.get_audit_inc_dtl (arg_run_id, arg_month_id, arg_member_id, arg_details_id, arg_audit_id, arg_currow)
  lstr_pass_ret = []
		lds_audit_inc_dtl = AuditTrailIncomeDetail.get_audit_trail_income_details(arg_run_id, arg_month_id, arg_member_id, arg_details_id, arg_audit_id)
		if (lds_audit_inc_dtl.present?  && arg_currow > 0 && lds_audit_inc_dtl.size >= arg_currow)
			count = 1
                lds_audit_inc_dtl.each do |audit_trail_income_detail|
                    if count == arg_currow
                        lstr_pass_ret[1] = audit_trail_income_detail.run_id #db[1]
						lstr_pass_ret[2] = audit_trail_income_detail.month_sequence #db[2]
						lstr_pass_ret[3] = audit_trail_income_detail.member_sequence #db[3]
						lstr_pass_ret[4] = audit_trail_income_detail.b_details_sequence #db[4]
						lstr_pass_ret[5] = audit_trail_income_detail.audit_trail_masters_id #db[5]
						lstr_pass_ret[6] = audit_trail_income_detail.gross_amt #db[6]
						lstr_pass_ret[7] = audit_trail_income_detail.adjusted_total #db[7]
						lstr_pass_ret[8] = audit_trail_income_detail.net_amt #db[8]
						lstr_pass_ret[9] = audit_trail_income_detail.id #db[9]
						lstr_pass_ret[10] = audit_trail_income_detail.date_received #dt[1]
						lstr_pass_ret[11] = audit_trail_income_detail.created_at #dt[2]
						lstr_pass_ret[12] = audit_trail_income_detail.check_type #s[1]
						lstr_pass_ret[13] = audit_trail_income_detail.created_by #s[2]

                        break
                    else
                        count = count + 1
                    end
                end

		end
		lstr_pass_ret[14] = lds_audit_inc_dtl.size
	 return lstr_pass_ret
end

# public function str_pass of_get_audit_inc_adj (double adb_run_id, double adb_month_id, double adb_member_id, double adb_details_id, double adb_audit_id, double adb_audit_det_id, long al_currow);str_pass lstr_pass_ret, lstr_pass_inc_adj
# n_ds lds_audit_inc_adj
# Long ll_row

# lds_audit_inc_adj = CREATE n_ds
# lds_audit_inc_adj.SetTransObject(SQLCA)
# lds_audit_inc_adj.DataObject = "dw_audit_trail_income_adj_details"

# lstr_pass_inc_adj.db[1] = adb_run_id
# lstr_pass_inc_adj.db[2] = adb_month_id
# lstr_pass_inc_adj.db[3] = adb_member_id
# lstr_pass_inc_adj.db[4] = adb_details_id
# lstr_pass_inc_adj.db[5] = adb_audit_id
# lstr_pass_inc_adj.db[6] = adb_audit_det_id

# ll_row = gnv_data_access_service.retrieve(lds_audit_inc_adj, lds_audit_inc_adj, "Atia_l", lstr_pass_inc_adj)

# IF (ll_row > 0) AND (al_currow > 0) AND (ll_row >= al_currow) THEN
# 	lstr_pass_ret.db[1] = lds_audit_inc_adj.GetItemNumber(al_currow, "bwiz_run_id")
# 	lstr_pass_ret.db[2] = lds_audit_inc_adj.GetItemNumber(al_currow, "bwiz_mo_id")
# 	lstr_pass_ret.db[3] = lds_audit_inc_adj.GetItemNumber(al_currow, "bmember_id")
# 	lstr_pass_ret.db[4] = lds_audit_inc_adj.GetItemNumber(al_currow, "b_details_id")
# 	lstr_pass_ret.db[5] = lds_audit_inc_adj.GetItemNumber(al_currow, "audit_id")

# 	lstr_pass_ret.db[6] = lds_audit_inc_adj.GetItemNumber(al_currow, "adj_amount")
# 	lstr_pass_ret.db[7] = lds_audit_inc_adj.GetItemNumber(al_currow, "audit_det_id")
# 	lstr_pass_ret.db[8] = lds_audit_inc_adj.GetItemNumber(al_currow, "audit_inc_adj_id")

# 	lstr_pass_ret.s[1] = lds_audit_inc_adj.GetItemString(al_currow, "adj_use_ind")
# 	lstr_pass_ret.s[2] = lds_audit_inc_adj.GetItemString(al_currow, "adj_reason")
# 	lstr_pass_ret.s[3] = lds_audit_inc_adj.GetItemString(al_currow, "user_id")

# 	lstr_pass_ret.dt[1] = lds_audit_inc_adj.GetItemDateTime(al_currow, "last_update")
# END IF

# lstr_pass_ret.i[1] = ll_row

# DESTROY lds_audit_inc_adj

# RETURN lstr_pass_ret

# //***********************************************************************
# //*  Release  Date     Task         Author                              *
# //*  Description                                                        *
# //***********************************************************************
# //*  9.06A    11/15/06 ANSWER			Evangeline L. Gutierez					*
# //*  PCR#68098																				*
# //*  Created this function to return the Audit Trail Income Adjustment.	*
# //***********************************************************************
# //*  10.01A    08/10/07 ANSWER			Evangeline L. Gutierez					*
# //*  PCR#74054
# //*  Added rowcount of income details on  the returning values.
# //* lstr_pass_ret.i[1] = ll_row
# //***********************************************************************
# end function

# public function str_pass of_get_audit_trail_shared (double adb_run_id, double adb_mo_id, double adb_member_id, double adb_b_details_id, double adb_audit_id, long al_currow);n_ds lds_audit_trail_shared_by
# str_pass lstr_pass, lstr_pass_ret
# Long ll_row

# lstr_pass.db[1] = adb_run_id
# lstr_pass.db[2] = adb_mo_id
# lstr_pass.db[3] = adb_member_id
# lstr_pass.db[4] = adb_b_details_id
# lstr_pass.db[5] = adb_audit_id

# lds_audit_trail_shared_by = CREATE n_ds
# lds_audit_trail_shared_by.SetTransObject(SQLCA)
# lds_audit_trail_shared_by.DataObject = "dw_audit_trail_shared_by"

# ll_row = gnv_data_access_service.retrieve(lds_audit_trail_shared_by, lds_audit_trail_shared_by, "Atsb_l", lstr_pass)

# IF (ll_row > 0) AND (al_currow > 0) AND (ll_row >= al_currow) THEN

# 	lstr_pass_ret.db[1] = lds_audit_trail_shared_by.GetItemNumber(al_currow, "t_audit_trl_shared_bwiz_run_id")
# 	lstr_pass_ret.db[2] = lds_audit_trail_shared_by.GetItemNumber(al_currow, "t_audit_trl_shared_bwiz_mo_id")
# 	lstr_pass_ret.db[3] = lds_audit_trail_shared_by.GetItemNumber(al_currow, "t_audit_trl_shared_bmember_id")
# 	lstr_pass_ret.db[4] = lds_audit_trail_shared_by.GetItemNumber(al_currow, "t_audit_trl_shared_b_details_id")
# 	lstr_pass_ret.db[5] = lds_audit_trail_shared_by.GetItemNumber(al_currow, "t_audit_trl_shared_audit_id")
# 	lstr_pass_ret.db[6] = lds_audit_trail_shared_by.GetItemNumber(al_currow, "t_audit_trl_shared_clientid")

# 	lstr_pass_ret.s[1] = lds_audit_trail_shared_by.GetItemString(al_currow, "t_audit_trl_shared_user_id")
# 	lstr_pass_ret.s[2] = lds_audit_trail_shared_by.GetItemString(al_currow, "t_person_biograph_ssn")
# 	lstr_pass_ret.s[3] = lds_audit_trail_shared_by.GetItemString(al_currow, "t_person_demograph_first_name")
# 	lstr_pass_ret.s[4] = lds_audit_trail_shared_by.GetItemString(al_currow, "t_person_demograph_middle_name")
# 	lstr_pass_ret.s[5] = lds_audit_trail_shared_by.GetItemString(al_currow, "t_person_demograph_suffix")
# 	lstr_pass_ret.s[6] = lds_audit_trail_shared_by.GetItemString(al_currow, "t_person_demograph_last_name")

# 	lstr_pass_ret.dt[1] = lds_audit_trail_shared_by.GetItemDateTime(al_currow, "t_audit_trl_shared_last_update") //10.01D, typo error on field name

# END IF

# lstr_pass_ret.i[1] = ll_row

# DESTROY lds_audit_trail_shared_by

# RETURN lstr_pass_ret

# //***********************************************************************
# //*  Release  Date     Task         Author                              *
# //*  Description                                                        *
# //***********************************************************************
# //*  9.06A    11/17/06 ANSWER			Evangeline L. Gutierez					*
# //*  PCR#68098																				*
# //*  Created this function to return the Audit Trail Income Shared.		*
# //***********************************************************************
# //*  10.01A    08/10/07 ANSWER			Evangeline L. Gutierez					*
# //*  PCR#74054
# //*  Added rowcount of income on  the returning values.
# //*  lstr_pass_ret.i[1] = ll_row
# //***********************************************************************

# end function

# public function str_pass of_create_audit_mstr (str_pass astr_pass);n_ds lds_audit_trail_income_details
# Long ll_row
# str_pass lstr_pass

# lds_audit_trail_income_details = CREATE n_ds
# lds_audit_trail_income_details.SetTransObject(SQLCA)
# lds_audit_trail_income_details.DataObject = "dw_audit_trail_income_details"

# ll_row = lds_audit_trail_income_details.InsertRow(0)
# lds_audit_trail_income_details.SetItem(ll_row, "bwiz_run_id", astr_pass.db[1])
# lds_audit_trail_income_details.SetItem(ll_row, "bwiz_mo_id", astr_pass.db[2])
# lds_audit_trail_income_details.SetItem(ll_row, "bmember_id", astr_pass.db[3])
# lds_audit_trail_income_details.SetItem(ll_row, "b_details_id", astr_pass.db[4])
# lds_audit_trail_income_details.SetItem(ll_row, "clientid", astr_pass.db[6] )
# lds_audit_trail_income_details.SetItem(ll_row, "service_program_id", astr_pass.db[7])
# lds_audit_trail_income_details.SetItem(ll_row, "intended_use_mos", astr_pass.db[8])
# lds_audit_trail_income_details.SetItem(ll_row, "contract_amt", astr_pass.db[9])

# lds_audit_trail_income_details.SetItem(ll_row, "source", astr_pass.s[1])
# lds_audit_trail_income_details.SetItem(ll_row, "bu_service_county", astr_pass.s[3])
# lds_audit_trail_income_details.SetItem(ll_row, "frequency", astr_pass.s[4])
# lds_audit_trail_income_details.SetItem(ll_row, "type", astr_pass.s[5])
# lds_audit_trail_income_details.SetItem(ll_row, "audit_det_ind", astr_pass.s[6])

# lds_audit_trail_income_details.SetItem(ll_row, "inc_avg_begin_date", astr_pass.dt[2])
# lds_audit_trail_income_details.SetItem(ll_row, "effective_beg_date", astr_pass.dt[3])
# lds_audit_trail_income_details.SetItem(ll_row, "effective_end_date", astr_pass.dt[4])

# lstr_pass.db[1] = 2   //set domain table ID (2 is for the id portion of the domain tbl)
# lstr_pass.db[2] = 61  //set sub domain id   (61 is for Audit Master ID)
# astr_pass.db[5] = gnv_data_access_service.system_generate_id(lstr_pass)

# lds_audit_trail_income_details.SetItem(ll_row, "audit_id", astr_pass.db[5])
# lds_audit_trail_income_details.SetItem(ll_row, "user_id", gs_current_user)
# lds_audit_trail_income_details.SetItem(ll_row, "last_update", datetime(gdt_current_date, now()))

# ll_row = gnv_data_access_service.update_service(lds_audit_trail_income_details, lds_audit_trail_income_details, "Atid_u", astr_pass)

# DESTROY lds_audit_trail_income_details

# RETURN astr_pass

# //***********************************************************************
# //*  Release  Date     Task         Author                              *
# //*  Description                                                        *
# //***********************************************************************
# //PCR#74054 ELGutierez
# end function

# public function str_pass of_create_audit_inc_dtl (str_pass astr_pass);str_pass lstr_pass
# n_ds lds_audit_inc_dtl
# Long ll_row

# lds_audit_inc_dtl = CREATE n_ds
# lds_audit_inc_dtl.SetTransObject(SQLCA)
# lds_audit_inc_dtl.DataObject = "dw_audit_trail_income_details_checks"

# ll_row = lds_audit_inc_dtl.InsertRow(0)
# lds_audit_inc_dtl.SetItem(ll_row, "bwiz_run_id", astr_pass.db[1])
# lds_audit_inc_dtl.SetItem(ll_row, "bwiz_mo_id", astr_pass.db[2])
# lds_audit_inc_dtl.SetItem(ll_row, "bmember_id", astr_pass.db[3])
# lds_audit_inc_dtl.SetItem(ll_row, "b_details_id", astr_pass.db[4])
# lds_audit_inc_dtl.SetItem(ll_row, "audit_id", astr_pass.db[5])
# lds_audit_inc_dtl.SetItem(ll_row, "gross_amount", astr_pass.db[6])
# lds_audit_inc_dtl.SetItem(ll_row, "adjusted_total", astr_pass.db[7])
# lds_audit_inc_dtl.SetItem(ll_row, "net_amount", astr_pass.db[8])
# lds_audit_inc_dtl.SetItem(ll_row, "date_received", astr_pass.dt[1])
# lds_audit_inc_dtl.SetItem(ll_row, "check_type", astr_pass.s[1])

# lstr_pass.db[1] = 2   //set domain table ID (2 is for the id portion of the domain tbl)
# lstr_pass.db[2] = 62  //set sub domain id   (62 is for Audit Detail ID)
# astr_pass.db[9] = gnv_data_access_service.system_generate_id(lstr_pass)

# lds_audit_inc_dtl.SetItem(ll_row, "audit_det_id", astr_pass.db[9])
# lds_audit_inc_dtl.SetItem(ll_row, "user_id", gs_current_user)
# lds_audit_inc_dtl.SetItem(ll_row, "last_update", Datetime(gdt_current_date, now()))

# ll_row = gnv_data_access_service.update_service(lds_audit_inc_dtl, lds_audit_inc_dtl, "Atic_u", astr_pass)

# DESTROY lds_audit_inc_dtl

# RETURN astr_pass

# //***********************************************************************
# //*  Release  Date     Task         Author                              *
# //*  Description                                                        *
# //***********************************************************************
# //*  PCR#74054
# //***********************************************************************
# end function

# public function str_pass of_create_audit_inc_adj (str_pass astr_pass);str_pass lstr_pass
# n_ds lds_audit_inc_adj
# Long ll_row

# lds_audit_inc_adj = CREATE n_ds
# lds_audit_inc_adj.SetTransObject(SQLCA)
# lds_audit_inc_adj.DataObject = "dw_audit_trail_income_adj_details"

# ll_row = lds_audit_inc_adj.InsertRow(0)
# lds_audit_inc_adj.SetItem(ll_row, "bwiz_run_id", astr_pass.db[1])
# lds_audit_inc_adj.SetItem(ll_row, "bwiz_mo_id", astr_pass.db[2])
# lds_audit_inc_adj.SetItem(ll_row, "bmember_id", astr_pass.db[3])
# lds_audit_inc_adj.SetItem(ll_row, "b_details_id", astr_pass.db[4])
# lds_audit_inc_adj.SetItem(ll_row, "audit_id", astr_pass.db[5])

# lds_audit_inc_adj.SetItem(ll_row, "adj_amount", astr_pass.db[6])
# lds_audit_inc_adj.SetItem(ll_row, "audit_det_id", astr_pass.db[7])

# lds_audit_inc_adj.SetItem(ll_row, "adj_use_ind", astr_pass.s[1])
# lds_audit_inc_adj.SetItem(ll_row, "adj_reason", astr_pass.s[2])


# lstr_pass.db[1] = 2   //set domain table ID (2 is for the id portion of the domain tbl)
# lstr_pass.db[2] = 63  //set sub domain id   (63 is for Audit Adjustment ID)
# astr_pass.db[8] = gnv_data_access_service.system_generate_id(lstr_pass)

# lds_audit_inc_adj.SetItem(ll_row, "audit_inc_adj_id", astr_pass.db[8])
# lds_audit_inc_adj.SetItem(ll_row, "user_id", gs_current_user)
# lds_audit_inc_adj.SetItem(ll_row, "last_update", DaTeTime(gdt_current_date, now()))

# ll_row = gnv_data_access_service.update_service(lds_audit_inc_adj, lds_audit_inc_adj, "Atia_u", astr_pass)

# DESTROY lds_audit_inc_adj

# RETURN astr_pass

# //***********************************************************************
# //*  Release  Date     Task         Author                              *
# //*  Description                                                        *
# //***********************************************************************
# //*  PCR#74054
# //***********************************************************************
# end function

# public function str_pass of_create_audit_trail_shared (str_pass astr_pass);n_ds lds_audit_trail_shared_by
# str_pass lstr_pass
# Long ll_row

# lds_audit_trail_shared_by = CREATE n_ds
# lds_audit_trail_shared_by.SetTransObject(SQLCA)
# lds_audit_trail_shared_by.DataObject = "dw_audit_trail_shared_by"

# ll_row = lds_audit_trail_shared_by.InsertRow(0)
# lds_audit_trail_shared_by.SetItem(ll_row, "t_audit_trl_shared_bwiz_run_id", astr_pass.db[1])
# lds_audit_trail_shared_by.SetItem(ll_row, "t_audit_trl_shared_bwiz_mo_id", astr_pass.db[2])
# lds_audit_trail_shared_by.SetItem(ll_row, "t_audit_trl_shared_bmember_id", astr_pass.db[3])
# lds_audit_trail_shared_by.SetItem(ll_row, "t_audit_trl_shared_b_details_id", astr_pass.db[4])
# lds_audit_trail_shared_by.SetItem(ll_row, "t_audit_trl_shared_audit_id", astr_pass.db[5])
# lds_audit_trail_shared_by.SetItem(ll_row, "t_audit_trl_shared_clientid", astr_pass.db[6])

# lds_audit_trail_shared_by.SetItem(ll_row, "t_person_biograph_ssn", astr_pass.s[2])
# lds_audit_trail_shared_by.SetItem(ll_row, "t_person_demograph_first_name", astr_pass.s[3])
# lds_audit_trail_shared_by.SetItem(ll_row, "t_person_demograph_middle_name", astr_pass.s[4])
# lds_audit_trail_shared_by.SetItem(ll_row, "t_person_demograph_suffix", astr_pass.s[5])
# lds_audit_trail_shared_by.SetItem(ll_row, "t_person_demograph_last_name", astr_pass.s[6])

# lds_audit_trail_shared_by.SetItem(ll_row, "t_audit_trl_shared_user_id", gs_current_user)
# lds_audit_trail_shared_by.SetItem(ll_row, "t_audit_trl_shared_last_update", DateTime(gdt_current_date, now())) //10.01D typo error on field name

# ll_row = gnv_data_access_service.update_service(lds_audit_trail_shared_by, lds_audit_trail_shared_by, "Atsb_u", astr_pass)

# DESTROY lds_audit_trail_shared_by

# RETURN astr_pass

# //***********************************************************************
# //*  Release  Date     Task         Author                              *
# //*  Description                                                        *
# //***********************************************************************
# //*  PCR#74054
# //***********************************************************************
# end function


end