function assessment_childcare(){
	if ($('#radio_926').is(':checked')){
      $('#caption_83').show();
	    $('#table_83_501').show();

      if ($('#radio_926').is(':checked')){
        $('#84_502').show();
        $('#84').show();
      }else{
        $('#84_502').hide();
        $('#84').hide();
      }
  }else {
    $('#caption_83').hide();
    $('#table_83_501').hide();

    $('#84_502').hide();
    $('#84').hide();

  }
}

$('#radio_926').click(function() {
  $('#caption_83').show();
  $('#table_83_501').show();

  if ($('#radio_926').is(':checked')){
    $('#84_502').show();
    $('#84').show();
  }

  if ($('#checkbox_940').is(':checked')){
    $('#84_502').show();
    $('#84').show();
  } else {
    $('#84_502').hide();
    $('#84').val('');
    $('#84').hide();
  }
});

$('#radio_927').click(function() {
    $("#caption_83").val('');
    $("#caption_83").hide();
    $('#checkbox_928').removeAttr('checked');
    $('#checkbox_929').removeAttr('checked');
    $('#checkbox_930').removeAttr('checked');
    $('#checkbox_931').removeAttr('checked');
    $('#checkbox_932').removeAttr('checked');
    $('#checkbox_933').removeAttr('checked');
    $('#checkbox_934').removeAttr('checked');
    $('#checkbox_935').removeAttr('checked');
    $('#checkbox_936').removeAttr('checked');
    $('#checkbox_937').removeAttr('checked');
    $('#checkbox_938').removeAttr('checked');
    $('#checkbox_939').removeAttr('checked');
    $('#checkbox_940').removeAttr('checked');
    $("#table_83_501").hide();


    $('#84_502').hide();
    $('#84').val('');
    $('#84').hide();

});

$('#checkbox_940').click(function() {
  if ($('#checkbox_940').is(':checked')){
    $('#84_502').show();
    $('#84').show();
  } else {
    $('#84_502').hide();
    $('#84').val('');
    $('#84').hide();
  }
});