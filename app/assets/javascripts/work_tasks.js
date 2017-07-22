function highlight_table_fields(){
  var table = document.getElementById("work_lists");
    var tbody = table.getElementsByTagName("tbody")[0];
    var rows = tbody.getElementsByTagName("tr");
    for (i=0; i < rows.length; i++) {
        var value = rows[i].getElementsByTagName("td")[4].firstChild.nodeValue;

        if ( value < 15) {
           rows[i].getElementsByTagName("td")[4].style.color = "green";
        }

           if (value < 5) {
            rows[i].getElementsByTagName("td")[4].style.color = "red";
        }


    }
}

function JS_WorkTask_Assignment_Type_User_Localoffice()
// Manoj 04/22/2015
// Description:  Based on Assignment to Type - User/Local office - User dropdown or Local office drop down is made visible.
{
   if (document.getElementById('assigned_to_type').value == 6342)
  {
      // User is selected.
      document.getElementById('assigned_to_user_div').style.display = 'inline';
      document.getElementById('assigned_to_local_office_div').style.display = 'none';

  }
  else
  {
    // Local Office  is selected.
    document.getElementById('assigned_to_local_office_div').style.display = 'inline';
    document.getElementById('assigned_to_user_div').style.display = 'none';
  }

}


