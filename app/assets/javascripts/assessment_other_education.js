//$("#element").val('');
function other_education() {
  if ($('#radio_36').is(':checked')){
        $('#221').show();
        $('#221_24').show();
  }else {
    $('#221').hide();
    $('#221_24').hide();
  }

  if ($('#radio_38').is(':checked')){
        $('#223').show();
        $('#223_26').show();
  }else {
    $('#223').hide();
    $('#223_26').hide();
  }

  if ($('#radio_40').is(':checked')){
        $('#225').show();
        $('#225_28').show();
  }else {
    $('#225').hide();
    $('#225_28').hide();
  }

  if ($('#radio_42').is(':checked')){
        $('#227').show();
        $('#227_30').show();
  }else {
    $('#227').hide();
    $('#227_30').hide();
  }

  if ($('#radio_44').is(':checked')){
        $('#229').show();
        $('#229_32').show();
  }else {
    $('#229').hide();
    $('#229_32').hide();
  }

  if ($('#radio_46').is(':checked')){
        $('#471').show();
        $('#471_34').show();
  }else {
    $('#471').hide();
    $('#471_34').hide();
  }
}

$('#radio_36').change(function() {
  if ($('#radio_36').is(':checked')){
        $('#221').show();
        $('#221_24').show();
  }
});

$('#radio_37').change(function() {
  if ($('#radio_37').is(':checked')){
    $("#221").val('');
    $('#221').hide();
    $('#221_24').hide();
  }
});

$('#radio_38').change(function() {
  if ($('#radio_38').is(':checked')){
        $('#223').show();
        $('#223_26').show();
  }
});

$('#radio_39').change(function() {
  if ($('#radio_39').is(':checked')){
    $("#223").val('');
    $('#223').hide();
    $('#223_26').hide();
  }
});

$('#radio_40').change(function() {
  if ($('#radio_40').is(':checked')){
    $('#225').show();
    $('#225_28').show();
  }
});

$('#radio_41').change(function() {
  if ($('#radio_41').is(':checked')){
    $("#225").val('');
    $('#225').hide();
    $('#225_28').hide();
  }
});

$('#radio_42').change(function() {
  if ($('#radio_42').is(':checked')){
    $('#227').show();
    $('#227_30').show();
  }
});

$('#radio_43').change(function() {
  if ($('#radio_43').is(':checked')){
    $("#227").val('');
    $('#227').hide();
    $('#227_30').hide();
  }
});

$('#radio_44').change(function() {
  if ($('#radio_44').is(':checked')){
    $('#229').show();
    $('#229_32').show();
  }
});

$('#radio_45').change(function() {
  if ($('#radio_45').is(':checked')){
    $("#229").val('');
    $('#229').hide();
    $('#229_32').hide();
  }
});

$('#radio_46').change(function() {
  if ($('#radio_46').is(':checked')){
    $('#471').show();
    $('#471_34').show();
  }
});

$('#radio_47').change(function() {
  if ($('#radio_47').is(':checked')){
    $("#471").val('');
    $('#471').hide();
    $('#471_34').hide();
  }
});