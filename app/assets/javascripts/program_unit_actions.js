function JS_tea_close_bonus_display(arg_object){
	// alert(arg_object.options[arg_object.selectedIndex].value
li_selected_action = document.getElementById('pgu_action_pgu_action_reason').value
li_service_program_id = document.getElementById('service_program').value
li_participation_status_close = document.getElementById('participation_status_close').value
		if (li_service_program_id == "1" && li_participation_status_close == "6100" && (li_selected_action == "4235" ) || (li_selected_action == "4229"  )||  (li_selected_action == "4236"  )|| (li_selected_action == "4237"  )|| (li_selected_action == "4300" )|| (li_selected_action == "4297"  )|| (li_selected_action == "4298"  ) || (li_selected_action == "4299"  )||  (li_selected_action == "4301"  )|| (li_selected_action == "4296"  )|| (li_selected_action == "4303"  ) )
		 // make the div visible
        document.getElementById('tea_close_bonus_div').style.display = 'inline';
        else
         // make the div invisible
         document.getElementById('tea_close_bonus_div').style.display = 'none';
}




