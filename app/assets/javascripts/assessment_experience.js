function experience(){
	if ($('#radio_276').is(':checked')){
      $('#682_161').show();
	    $('#682').show();
  }else {
    $('#682_161').hide();
    $('#682').hide();
  }
}

$('#radio_276').change(function() {
  if ($('#radio_276').is(':checked')){
    $('#682_161').show();
    $('#682').show();
  }
});

$('#radio_277').change(function() {
  if ($('#radio_277').is(':checked')){
    $("#682_161").val('');
    $("#682").val('');
    $('#682_161').hide();
    $('#682').hide();
  }
});