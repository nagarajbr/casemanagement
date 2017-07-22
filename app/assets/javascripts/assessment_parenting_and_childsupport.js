function parenting_and_childsupport(){

  if ($('#radio_1065').is(':checked')) {

    if ($('#radio_903').is(':checked')){
        $('#564_484').show();
        $('#564').show();
    }else {
      $('#564_484').hide();
      $('#564').hide();
    }

    if ($('#radio_904').is(':checked')){
      $('#727_486').show();
      $('#727').show();
      $('#727').attr('placeholder','$');
      $('#727').attr('onkeypress','return isCurrency(event)');
      $('#727').attr('onkeyup','setDecimalValue(event)');

      $('#div_728').show();
      $('#728_487_906').show();
      $('#728_487_907').show();
      $('#radio_906').show();
      $('#radio_907').show();

      $('#div_729').show();
      $('#729_488_908').show();
      $('#729_488_909').show();
    }else {
      $('#727_486').hide();
      $('#727').hide();

      $('#div_728').hide();
      $('#728_487_906').hide();
      $('#728_487_907').hide();
      $('#radio_906').hide();
      $('#radio_907').hide();

      $('#div_729').hide();
      $('#729_488_908').hide();
      $('#729_488_909').hide();
      if ($('#radio_905').is(':checked')){
        $('#div_730').show();
        $('#730_489_910').show();
        $('#730_489_911').show();
      } else {
        $('#div_730').hide();
        $('#730_489_910').hide();
        $('#730_489_911').hide();
      }
    }

    if ($('#radio_912').is(':checked')){
      $('#567_491').show();
      $('#567').show();
      $('#567').attr('placeholder','$');
      $('#567').attr('onkeypress','return isCurrency(event)');
      $('#567').attr('onkeyup','setDecimalValue(event)');

      $('#div_765').show();
      $('#765_492_914').show();
      $('#765_492_915').show();

      $('#div_766').show();
      $('#766_493_916').show();
      $('#766_493_917').show();
    }else {
      $('#567_491').hide();
      $('#567').hide();

      $('#div_765').hide();
      $('#765_492_914').hide();
      $('#765_492_915').hide();

      $('#div_766').hide();
      $('#766_493_916').hide();
      $('#766_493_917').hide();
      if ($('#radio_913').is(':checked')){
        $('#div_767').show();
        $('#767_494_918').show();
        $('#767_494_919').show();
      } else {
        $('#div_767').hide();
        $('#767_494_918').hide();
        $('#767_494_919').hide();
      }
    }

    if ($('#radio_920').is(':checked')){
      $('#div_569').show();
      $('#569_497_922').show();
      $('#569_497_923').show();

      $('#div_571').show();
      $('#571_498_924').show();
      $('#571_498_925').show();

      $('#570_496').hide();
      $('#570').hide();
    }else {
      if ($('#radio_921').is(':checked')){
        $('#570_496').show();
        $('#570').show();
      }else{
        $('#570_496').hide();
        $('#570').hide();
      }
      $('#div_569').hide();
      $('#569_497_922').hide();
      $('#569_497_923').hide();

      $('#div_571').hide();
      $('#571_498_924').hide();
      $('#571_498_925').hide();
    }
  } else {
    hide_parenting_and_child_support_elements();
  }
}

function hide_parenting_and_child_support_elements(){
  $('#563_483').hide();
    $('#table_563_483').hide();

    $('#564_484').hide();
    $('#564').hide();

    $('#div_565').hide();
    $('#565_485_904').hide();
    $('#565_485_905').hide();


    $('#727_486').hide();
    $('#727').hide();

    $('#div_728').hide();
    $('#728_487_906').hide();
    $('#728_487_907').hide();

    $('#div_729').hide();
    $('#729_488_908').hide();
    $('#729_488_909').hide();

    $('#div_730').hide();
    $('#730_489_910').hide();
    $('#730_489_911').hide();

    $('#div_566').hide();
    $('#566_490_912').hide();
    $('#566_490_913').hide();

    $('#567_491').hide();
    $('#567').hide();

    $('#div_765').hide();
    $('#765_492_914').hide();
    $('#765_492_915').hide();

    $('#div_766').hide();
    $('#766_493_916').hide();
    $('#766_493_917').hide();

    $('#div_767').hide();
    $('#767_494_918').hide();
    $('#767_494_919').hide();

    $('#div_568').hide();
    $('#568_495_920').hide();
    $('#568_495_921').hide();

    $('#570_496').hide();
    $('#570').hide();

    $('#div_569').hide();
    $('#569_497_922').hide();
    $('#569_497_923').hide();

    $('#div_571').hide();
    $('#571_498_924').hide();
    $('#571_498_925').hide();
}

function initialize_parenting_and_child_support_eleemnts(){
  $('#radio_900').removeAttr('checked');
  $('#radio_901').removeAttr('checked');
  $('#radio_902').removeAttr('checked');
  $('#radio_903').removeAttr('checked');

  $('#564').val('');

  $('#radio_904').removeAttr('checked');
  $('#radio_905').removeAttr('checked');


  $('#727').val('');

  $('#radio_906').hide();
  $('#radio_907').hide();


  $('#radio_908').removeAttr('checked');
  $('#radio_909').removeAttr('checked');

  $('#radio_910').removeAttr('checked');
  $('#radio_911').removeAttr('checked');

  $('#radio_912').removeAttr('checked');
  $('#radio_913').removeAttr('checked');

  $('#567').val('');

  $('#radio_914').removeAttr('checked');
  $('#radio_915').removeAttr('checked');

  $('#radio_916').removeAttr('checked');
  $('#radio_917').removeAttr('checked');

  $('#radio_918').removeAttr('checked');
  $('#radio_919').removeAttr('checked');

  $('#radio_920').removeAttr('checked');
  $('#radio_921').removeAttr('checked');

  $('#570').val('');

  $('#radio_922').removeAttr('checked');
  $('#radio_923').removeAttr('checked');

  $('#radio_924').removeAttr('checked');
  $('#radio_925').removeAttr('checked');
}

$('#radio_1065').click(function() {
    $('#563_483').show();
    $('#table_563_483').show();

    if ($('#radio_903').is(':checked')){
      $('#564_484').show();
      $('#564').show();
    }else {
      $('#564_484').hide();
      $('#564').hide();
    }

    $('#div_565').show();
    $('#565_485_904').show();
    $('#565_485_905').show();

    if ($('#radio_904').is(':checked')){
      $('#727_486').show();
      $('#727').show();
      $('#727').attr('placeholder','$');
      $('#727').attr('onkeypress','return isCurrency(event)');
      $('#727').attr('onkeyup','setDecimalValue(event)');

      $('#div_728').show();
      $('#728_487_906').show();
      $('#728_487_907').show();

      $('#div_729').show();
      $('#729_488_908').show();
      $('#729_488_909').show();
    }else {
      $('#727_486').hide();
      $('#727').hide();

      $('#div_728').hide();
      $('#728_487_906').hide();
      $('#728_487_907').hide();

      $('#div_729').hide();
      $('#729_488_908').hide();
      $('#729_488_909').hide();
      if ($('#radio_905').is(':checked')){
        $('#div_730').show();
        $('#730_489_910').show();
        $('#730_489_911').show();
      } else {
        $('#div_730').hide();
        $('#730_489_910').hide();
        $('#730_489_911').hide();
      }
    }


    $('#div_566').show();
    $('#566_490_912').show();
    $('#566_490_913').show();

    if ($('#radio_912').is(':checked')){
      $('#567_491').show();
      $('#567').show();
      $('#567').attr('placeholder','$');
      $('#567').attr('onkeypress','return isCurrency(event)');
      $('#567').attr('onkeyup','setDecimalValue(event)');

      $('#div_765').show();
      $('#765_492_914').show();
      $('#765_492_915').show();

      $('#div_766').show();
      $('#766_493_916').show();
      $('#766_493_917').show();
    }else {
      $('#567_491').hide();
      $('#567').hide();

      $('#div_765').hide();
      $('#765_492_914').hide();
      $('#765_492_915').hide();

      $('#div_766').hide();
      $('#766_493_916').hide();
      $('#766_493_917').hide();
      if ($('#radio_913').is(':checked')){
        $('#div_767').show();
        $('#767_494_918').show();
        $('#767_494_919').show();
      } else {
        $('#div_767').hide();
        $('#767_494_918').hide();
        $('#767_494_919').hide();
      }
    }

    $('#div_568').show();
    $('#568_495_920').show();
    $('#568_495_921').show();

    if ($('#radio_920').is(':checked')){
      $('#div_569').show();
      $('#569_497_922').show();
      $('#569_497_923').show();

      $('#div_571').show();
      $('#571_498_924').show();
      $('#571_498_925').show();

      $('#570_496').hide();
      $('#570').hide();
    }else {
      if ($('#radio_921').is(':checked')){
        $('#570_496').show();
        $('#570').show();
      }else{
        $('#570_496').hide();
        $('#570').hide();
      }
      $('#div_569').hide();
      $('#569_497_922').hide();
      $('#569_497_923').hide();

      $('#div_571').hide();
      $('#571_498_924').hide();
      $('#571_498_925').hide();
    }
});

$('#radio_1066').click(function() {
  hide_parenting_and_child_support_elements();
  initialize_parenting_and_child_support_eleemnts();
});

$('#radio_903').click(function() {
  $('#564_484').show();
  $('#564').show();
});

$('#radio_900').click(function() {
  $('#564_484').hide();
  $('#564').val('');
  $('#564').hide();
});

$('#radio_901').click(function() {
  $('#564_484').hide();
  $('#564').val('');
  $('#564').hide();
});

$('#radio_902').click(function() {
  $('#564_484').hide();
  $('#564').val('');
  $('#564').hide();
});

$('#radio_904').click(function() {
  $('#727_486').show();
  $('#727').show();
  $('#727').attr('placeholder','$');
  $('#727').attr('onkeypress','return isCurrency(event)');
  $('#727').attr('onkeyup','setDecimalValue(event)');


  $('#div_728').show();
  $('#728_487_906').show();
  $('#728_487_907').show();

  $('#div_729').show();
  $('#729_488_908').show();
  $('#729_488_909').show();

  $('#div_730').hide();
  $('#radio_910').removeAttr('checked');
  $('#radio_911').removeAttr('checked');
  $('#730_489_910').hide();
  $('#730_489_911').hide();

});

$('#radio_905').click(function() {
  $('#727_486').hide();
  $('#727').val('');
  $('#727').hide();

  $('#div_728').hide();
  $('#radio_906').removeAttr('checked');
  $('#radio_907').removeAttr('checked');
  $('#728_487_906').hide();
  $('#728_487_907').hide();

  $('#div_729').hide();
  $('#radio_908').removeAttr('checked');
  $('#radio_909').removeAttr('checked');
  $('#729_488_908').hide();
  $('#729_488_909').hide();

  $('#div_730').show();
  $('#730_489_910').show();
  $('#730_489_911').show();
});

$('#radio_912').click(function() {
  $('#567_491').show();
  $('#567').show();
  $('#567').attr('placeholder','$');
  $('#567').attr('onkeypress','return isCurrency(event)');
  $('#567').attr('onkeyup','setDecimalValue(event)');

  $('#div_765').show();
  $('#765_492_914').show();
  $('#765_492_915').show();

  $('#div_766').show();
  $('#766_493_916').show();
  $('#766_493_917').show();

  $('#div_767').hide();
  $('#radio_918').removeAttr('checked');
  $('#radio_919').removeAttr('checked');
  $('#767_494_918').hide();
  $('#767_494_919').hide();

});

$('#radio_913').click(function() {
  $('#567_491').hide();
  $('#567').val('');
  $('#567').hide();

  $('#div_765').hide();
  $('#radio_914').removeAttr('checked');
  $('#radio_915').removeAttr('checked');
  $('#765_492_914').hide();
  $('#765_492_915').hide();

  $('#div_766').hide();
  $('#radio_916').removeAttr('checked');
  $('#radio_917').removeAttr('checked');
  $('#766_493_916').hide();
  $('#766_493_917').hide();

  $('#div_767').show();
  $('#767_494_918').show();
  $('#767_494_919').show();
});

$('#radio_920').click(function() {

  $('#div_569').show();
    $('#569_497_922').show();
    $('#569_497_923').show();

    $('#div_571').show();
    $('#571_498_924').show();
    $('#571_498_925').show();

  $('#570_496').hide();
  $('#570').val('');
    $('#570').hide();

});

$('#radio_921').click(function() {
    $('#570_496').show();
    $('#570').show();

    $('#div_569').hide();
    $('#radio_922').removeAttr('checked');
    $('#radio_923').removeAttr('checked');
    $('#569_497_922').hide();
    $('#569_497_923').hide();

    $('#div_571').hide();
    $('#radio_924').removeAttr('checked');
    $('#radio_925').removeAttr('checked');
    $('#571_498_924').hide();
    $('#571_498_925').hide();
});