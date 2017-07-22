function backup_chlidren_plan(){
	if ($('#radio_941').is(':checked')){
      $('#527_505').show();
      $('#527').show();
  }else {
    $('#527_505').hide();
    $('#527').hide();
  }
}

$('#radio_941').change(function() {
  if ($('#radio_941').is(':checked')){
    $('#527_505').show();
    $('#527').show();
  }
});

$('#radio_942').change(function() {
  if ($('#radio_942').is(':checked')){
    $('#527_505').hide();
    $('#527').val('');
    $('#527').hide();
  }
});