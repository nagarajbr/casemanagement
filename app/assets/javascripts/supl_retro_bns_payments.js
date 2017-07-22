
function set_payment_amount(){
    var payment_type = document.getElementById('supplement_pymt_type').value
    if (payment_type == 6228) {
        document.getElementById('payment_month').value = document.getElementById('current_date').value;
        document.getElementById('payment_month').readOnly =true;
    }else  {
        if (document.getElementById('payment_month').readOnly) {
            document.getElementById('payment_month').readOnly =false;
            document.getElementById('payment_month').value = ""
        }
    }

    if (payment_type == 6230 || payment_type == 6231 || payment_type == 6232 || payment_type == 6233){
        document.getElementById('bonus_payment_amount').value = document.getElementById('bonus_pymt_amt').value;
        document.getElementById('bonus_payment_amount').readOnly =true;
    }else {
        if (document.getElementById('bonus_payment_amount').readOnly) {
            document.getElementById('bonus_payment_amount').readOnly =false;
            document.getElementById('bonus_payment_amount').value = '$'
        }

    }
}
