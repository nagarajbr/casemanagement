def client_attributes(overrides = {})  
  {
    first_name: "Kiran",
    middle_name: "",
    last_name: "Chamarthi",
    suffix: "",
    ssn: "123456789",
    dob: "2014-04-19",
    sex: 1,
    marital_status: 1,
    primary_language:1,
    created_by:"1",
    updated_by:"1"
  }.merge(overrides)
end

def income_attributes(overrides = {})
  {
    incometype: "2658",
    source: "C:",
    verified: "1",
    frequency: "2862",
    effective_beg_date:"2014-07-30",
    effective_end_date:"2014-07-31",
    intended_use_mos:"12",
    contract_amt:"120.00",
    inc_avg_beg_date:"2014-07-30",
    notes:"test data",
    recal_ind:"1",
    created_by:"1",
    updated_by:"1"
  }.merge(overrides)
end

def income_detail_attributes(overrides = {})
  {
    date_received: "2014-07-30",
    check_type: "4385",
    gross_amt: "120.00",
    cnt_for_convert_ind: "1",
    created_by:"1",
    updated_by:"1"
  }.merge(overrides)
end

def income_detail_adjustment_attributes(overrides = {})
  {
    adjusted_amount: 138.18,
    adjusted_reason: 4454,    
    created_by:"1",
    updated_by:"1"
  }.merge(overrides)
end

def expense_detail_attributes(overrides = {})
  {
    expense_id: 1,
    expense_due_date: "2014-07-30",
    expense_amount: "120.00",
    expense_use_code: "1",
    payment_method: "1",
    payment_status: "1",
    expense_calc_ind: "1",
    created_by: "1",                                       
    updated_by:"1",
    created_at:"1", 
    updated_at:"1",
  }.merge(overrides)
end



def expense_attributes(overrides = {})
  {
    expensetype: "1",
    amount: "120.00",
    effective_beg_date: "2014-07-30",
    effective_end_date: "2014-08-30",
    creditor_name: "temp",
    creditor_contact: "1234567890",
    creditor_phone: "9874563210",
    creditor_ext: "1234",
    payment_status: "1",
    frequency: "1",
    payment_method: "1",
    verified: "1",
    notes: "1",
    use_code: "1",
    exp_calc_months: "1",
    budget_recalc_ind: "1",
    created_by: "1",
    updated_by: "1",
    created_at: "1",
    updated_at: "1",
  }.merge(overrides)
end