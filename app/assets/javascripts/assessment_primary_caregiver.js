function primary_caregiver(){
	if ($('#radio_873').is(':checked')){
      $('#80_481').show();
      $('#80').show();
  }else {
    $('#80_481').hide();
    $('#80').hide();
  }
}

$('#radio_873').change(function() {
  if ($('#radio_873').is(':checked')){
    $('#80_481').show();
    $('#80').show();
  }
});

$('#radio_874').change(function() {
  if ($('#radio_874').is(':checked')){
    $('#80_481').hide();
    $('#80').val('');
    $('#80').hide();
  }
});