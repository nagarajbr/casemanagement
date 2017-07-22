function health_challenge(){
	if ($('#radio_381').is(':checked')){
      $('#71_211').show();
	    $('#71').show();
  }else {
    $('#71_211').hide();
    $('#71').hide();
  }
}

$('#radio_381').change(function() {
  if ($('#radio_381').is(':checked')){
    $('#71_211').show();
    $('#71').show();
  }
});

$('#radio_382').change(function() {
  if ($('#radio_382').is(':checked')){
    $('#71_211').hide();
    $("#71").val('');
    $('#71').hide();
  }
});