function js_other_identification_document(){
    li_participation_identification_type = document.getElementById('client_identification_type').value
    if (li_participation_identification_type == "4599" )
        document.getElementById('client_other_identification_document').style.display = 'inline';
       else
        document.getElementById('client_other_identification_document').style.display = 'none';
}


// window.onload = function js_other_identification_document() {
//     li_participation_identification_type = document.getElementById('client_identification_type').value
//     if (li_participation_identification_type == "4599" )
//     document.getElementById('client_other_identification_document').style.display = 'inline';
//     else
//     document.getElementById('client_other_identification_document').style.display = 'none';
// };
