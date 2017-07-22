function set_action_plan_outcome(){
  if (document.getElementById('action_plan_status').value == 6044) {
      document.getElementById('action_plan_outcome').style.display = 'inline';
  }else {
      document.getElementById('action_plan_outcome').style.display = 'none';
  }
}