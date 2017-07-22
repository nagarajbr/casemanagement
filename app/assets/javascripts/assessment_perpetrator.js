function perpetrator(){
  if (violence_perpetrator_menu_items_invisibility()){
    clear_perpetrator_html_attributes();
    hide_domestic_perpetrator_menu_items();
  }else{
    show_domestic_violence_perpetrator_menu_items();
  }
}


function hide_domestic_perpetrator_menu_items(){
  $('#884_606').hide();
  $('#861_382').hide();
  $('#table_715').hide();
  $('#table_716').hide();
  $('#717_385').hide();
  $('#div_862').hide();
  $('#862_386_667').hide();
  $('#862_386_668').hide();
  $('#div_718').hide();
  $('#718_387_669').hide();
  $('#718_387_670').hide();
  $('#777_388').hide();
  $('#div_863').hide();
  $('#863_389_671').hide();
  $('#863_389_672').hide();
  $('#div_778').hide();
  $('#778_390_673').hide();
  $('#778_390_674').hide();
  $('#719_391').hide();
  $('#div_864').hide();
  $('#864_392_675').hide();
  $('#864_392_676').hide();
  $('#div_779').hide();
  $('#779_393_677').hide();
  $('#779_393_678').hide();
  $('#768_394').hide();
  $('#div_865').hide();
  $('#865_395_679').hide();
  $('#865_395_680').hide();
  $('#div_769').hide();
  $('#769_396_681').hide();
  $('#769_396_682').hide();
  $('#770_397').hide();
  $('#div_866').hide();
  $('#866_398_683').hide();
  $('#866_398_684').hide();
  $('#div_771').hide();
  $('#771_399_685').hide();
  $('#771_399_686').hide();
  $('#772_400').hide();
  $('#div_867').hide();
  $('#867_401_687').hide();
  $('#867_401_688').hide();
  $('#div_773').hide();
  $('#773_402_689').hide();
  $('#773_402_690').hide();
  $('#789_403').hide();
  $('#div_868').hide();
  $('#868_404_691').hide();
  $('#868_404_692').hide();
  $('#div_790').hide();
  $('#790_405_693').hide();
  $('#790_405_694').hide();
  $('#791_406').hide();
  $('#div_869').hide();
  $('#869_407_695').hide();
  $('#869_407_696').hide();
  $('#div_792').hide();
  $('#792_408_697').hide();
  $('#792_408_698').hide();
  $('#793_409').hide();
  $('#div_870').hide();
  $('#870_410_699').hide();
  $('#870_410_700').hide();
  $('#div_794').hide();
  $('#794_411_701').hide();
  $('#794_411_702').hide();
  $('#795_412').hide();
  $('#div_871').hide();
  $('#871_413_703').hide();
  $('#871_413_704').hide();
  $('#div_796').hide();
  $('#796_414_705').hide();
  $('#796_414_706').hide();
  $('#797_415').hide();
  $('#div_872').hide();
  $('#872_416_707').hide();
  $('#872_416_708').hide();
  $('#div_800').hide();
  $('#800_417_709').hide();
  $('#800_417_710').hide();
  $('#799_418').hide();
  $('#div_873').hide();
  $('#873_419_711').hide();
  $('#873_419_712').hide();
  $('#div_802').hide();
  $('#802_420_713').hide();
  $('#802_420_714').hide();
  $('#801_421').hide();
  $('#div_874').hide();
  $('#874_422_715').hide();
  $('#874_422_716').hide();
  $('#div_798').hide();
  $('#798_423_717').hide();
  $('#798_423_718').hide();
  $('#div_713').hide();
  $('#713_424_719').hide();
  $('#713_424_720').hide();
  $('#714_425').hide();
  $('#714').hide();
  $('#div_216').hide();
  $('#216_426_721').hide();
  $('#216_426_722').hide();

  }

function show_domestic_violence_perpetrator_menu_items(){
  $('#884_606').show();
  $('#861_382').show();
  $('#table_715').show();
  $('#table_716').show();
  $('#717_385').show();
  $('#div_862').show();
  $('#862_386_667').show();
  $('#862_386_668').show();
  if ($('#radio_667').is(':checked')){
      $('#div_718').show();
      $('#718_387_669').show();
      $('#718_387_670').show();
  }else {
    $('#div_718').hide();
    $('#718_387_669').hide();
    $('#718_387_670').hide();
  }
  $('#777_388').show();
  $('#div_863').show();
  $('#863_389_671').show();
  $('#863_389_672').show();
   if ($('#radio_671').is(':checked')){
      $('#div_778').show();
      $('#778_390_673').show();
      $('#778_390_674').show();
  }else {
    $('#div_778').hide();
    $('#778_390_673').hide();
    $('#778_390_674').hide();
  }
  $('#719_391').show();
  $('#div_864').show();
  $('#864_392_675').show();
  $('#864_392_676').show();
  if ($('#radio_675').is(':checked')){
      $('#div_779').show();
      $('#779_393_677').show();
      $('#779_393_678').show();
  }else {
    $('#div_779').hide();
    $('#779_393_677').hide();
    $('#779_393_678').hide();
  }
  $('#768_394').show();
  $('#div_865').show();
  $('#865_395_679').show();
  $('#865_395_680').show();
  if ($('#radio_679').is(':checked')){
      $('#div_769').show();
      $('#769_396_681').show();
      $('#769_396_682').show();
  }else {
    $('#div_769').hide();
    $('#769_396_681').hide();
    $('#769_396_682').hide();
  }
  $('#770_397').show();
  $('#div_866').show();
  $('#866_398_683').show();
  $('#866_398_684').show();
  if ($('#radio_683').is(':checked')){
      $('#div_771').show();
      $('#769_396_681').show();
      $('#769_396_682').show();
  }else {
    $('#div_771').hide();
    $('#771_399_685').hide();
    $('#771_399_686').hide();
  }
  $('#772_400').show();
  $('#div_867').show();
  $('#867_401_687').show();
  $('#867_401_688').show();
  if ($('#radio_687').is(':checked')){
      $('#div_773').show();
      $('#773_402_689').show();
      $('#773_402_690').show();
  }else {
    $('#div_773').hide();
    $('#773_402_689').hide();
    $('#773_402_690').hide();
  }
  $('#789_403').show();
  $('#div_868').show();
  $('#868_404_691').show();
  $('#868_404_692').show();
  if ($('#radio_691').is(':checked')){
      $('#div_790').show();
      $('#790_405_693').show();
      $('#790_405_694').show();
  }else {
    $('#div_790').hide();
    $('#790_405_693').hide();
    $('#790_405_694').hide();
  }
  $('#791_406').show();
  $('#div_869').show();
  $('#869_407_695').show();
  $('#869_407_696').show();
  if ($('#radio_695').is(':checked')){
      $('#div_792').show();
      $('#792_408_697').show();
      $('#792_408_698').show();
  }else {
    $('#div_792').hide();
    $('#792_408_697').hide();
    $('#792_408_698').hide();
  }
  $('#793_409').show();
  $('#div_870').show();
  $('#870_410_699').show();
  $('#870_410_700').show();
  if ($('#radio_699').is(':checked')){
      $('#div_794').show();
      $('#794_411_701').show();
      $('#794_411_702').show();
  }else {
    $('#div_794').hide();
    $('#794_411_701').hide();
    $('#794_411_702').hide();
  }
  $('#795_412').show();
  $('#div_871').show();
  $('#871_413_703').show();
  $('#871_413_704').show();
  if ($('#radio_703').is(':checked')){
      $('#div_796').show();
      $('#796_414_705').show();
      $('#796_414_706').show();
  }else {
    $('#div_796').hide();
    $('#796_414_705').hide();
    $('#796_414_706').hide();
  }
  $('#797_415').show();
  $('#div_872').show();
  $('#872_416_707').show();
  $('#872_416_708').show();
 if ($('#radio_707').is(':checked')){
      $('#div_800').show();
      $('#800_417_709').show();
      $('#800_417_710').show();
  }else {
    $('#div_800').hide();
    $('#800_417_709').hide();
    $('#800_417_710').hide();
  }
  $('#799_418').show();
  $('#div_873').show();
  $('#873_419_711').show();
  $('#873_419_712').show();
  if ($('#radio_711').is(':checked')){
      $('#div_802').show();
      $('#802_420_713').show();
      $('#802_420_714').show();
  }else {
    $('#div_802').hide();
    $('#802_420_713').hide();
    $('#802_420_714').hide();
  }
  $('#801_421').show();
  $('#div_874').show();
  $('#874_422_715').show();
  $('#874_422_716').show();
  if ($('#radio_715').is(':checked')){
      $('#div_798').show();
      $('#798_423_717').show();
      $('#798_423_718').show();
  }else {
    $('#div_798').hide();
    $('#798_423_717').hide();
    $('#798_423_718').hide();
  }

  $('#div_713').show();
  $('#713_424_719').show();
  $('#713_424_720').show();
  if ($('#radio_719').is(':checked')){
      $('#714_425').show();
      $('#714').show();
       $('#div_216').hide();
       $('#216_426_721').hide();
       $('#216_426_722').hide();

  }else {
    $('#714_425').hide();
    $('#714').hide();
    $('#div_216').show();
       $('#216_426_721').show();
       $('#216_426_722').show();
  }

}

$('#radio_667').click(function() {
    $('#div_718').show();
    $('#718_387_669').show();
    $('#718_387_670').show();
});

$('#radio_668').click(function() {
  $('#div_718').hide();
  $('#radio_669').removeAttr('checked');
  $('#radio_670').removeAttr('checked');
  $('#718_387_669').hide();
  $('#718_387_670').hide();
});

$('#radio_671').click(function() {
    $('#div_778').show();
    $('#778_390_673').show();
    $('#778_390_674').show();
});

$('#radio_672').click(function() {
  $('#div_778').hide();
  $('#radio_673').removeAttr('checked');
  $('#radio_674').removeAttr('checked');
  $('#778_390_673').hide();
  $('#778_390_674').hide();
});

$('#radio_675').click(function() {
    $('#div_779').show();
    $('#779_393_677').show();
    $('#779_393_678').show();
});

$('#radio_676').click(function() {
  $('#div_779').hide();
  $('#radio_677').removeAttr('checked');
  $('#radio_678').removeAttr('checked');
  $('#779_393_677').hide();
  $('#779_393_678').hide();
});

$('#radio_679').click(function() {
    $('#div_769').show();
    $('#769_396_681').show();
    $('#769_396_682').show();
});

$('#radio_680').click(function() {
  $('#div_769').hide();
  $('#radio_681').removeAttr('checked');
  $('#radio_682').removeAttr('checked');
  $('#769_396_681').hide();
  $('#769_396_682').hide();
});

$('#radio_683').click(function() {
    $('#div_771').show();
    $('#771_399_685').show();
    $('#771_399_686').show();
});

$('#radio_684').click(function() {
  $('#div_771').hide();
  $('#radio_685').removeAttr('checked');
  $('#radio_686').removeAttr('checked');
  $('#771_399_685').hide();
  $('#771_399_686').hide();
});

$('#radio_687').click(function() {
    $('#div_773').show();
    $('#773_402_689').show();
    $('#773_402_690').show();
});

$('#radio_688').click(function() {
  $('#div_773').hide();
  $('#radio_689').removeAttr('checked');
  $('#radio_690').removeAttr('checked');
  $('#773_402_689').hide();
  $('#773_402_690').hide();
});

$('#radio_691').click(function() {
    $('#div_790').show();
    $('#790_405_693').show();
    $('#790_405_694').show();
});

$('#radio_692').click(function() {
  $('#div_790').hide();
  $('#radio_693').removeAttr('checked');
  $('#radio_694').removeAttr('checked');
  $('#790_405_693').hide();
  $('#790_405_694').hide();
});

$('#radio_695').click(function() {
    $('#div_792').show();
    $('#792_408_697').show();
    $('#792_408_698').show();
});

$('#radio_696').click(function() {
  $('#div_792').hide();
  $('#radio_697').removeAttr('checked');
  $('#radio_698').removeAttr('checked');
  $('#792_408_697').hide();
  $('#792_408_698').hide();
});

$('#radio_699').click(function() {
    $('#div_794').show();
    $('#794_411_701').show();
    $('#794_411_702').show();
});

$('#radio_700').click(function() {
  $('#div_794').hide();
  $('#radio_701').removeAttr('checked');
  $('#radio_702').removeAttr('checked');
  $('#794_411_701').hide();
  $('#794_411_702').hide();
});

$('#radio_703').click(function() {
    $('#div_796').show();
    $('#796_414_705').show();
    $('#796_414_706').show();
});

$('#radio_704').click(function() {
  $('#div_796').hide();
  $('#radio_705').removeAttr('checked');
  $('#radio_706').removeAttr('checked');
  $('#796_414_705').hide();
  $('#796_414_706').hide();
});

$('#radio_707').click(function() {
    $('#div_800').show();
    $('#800_417_709').show();
    $('#800_417_710').show();
});

$('#radio_708').click(function() {
  $('#div_800').hide();
  $('#radio_709').removeAttr('checked');
  $('#radio_710').removeAttr('checked');
  $('#800_417_709').hide();
  $('#800_417_710').hide();
});

$('#radio_711').click(function() {
    $('#div_802').show();
    $('#802_420_713').show();
    $('#802_420_714').show();
});

$('#radio_712').click(function() {
  $('#div_802').hide();
  $('#radio_713').removeAttr('checked');
  $('#radio_714').removeAttr('checked');
  $('#802_420_713').hide();
  $('#802_420_714').hide();
});

$('#radio_715').click(function() {
    $('#div_798').show();
    $('#798_423_717').show();
    $('#798_423_718').show();
});

$('#radio_716').click(function() {
  $('#div_798').hide();
  $('#radio_717').removeAttr('checked');
  $('#radio_718').removeAttr('checked');
  $('#798_423_717').hide();
  $('#798_423_718').hide();
});

$('#radio_719').click(function() {
    $('#714_425').show();
    $('#714').show();
    $('#div_216').hide();
    $('#216_426_721').hide();
     $('#216_426_722').hide();



});

$('#radio_720').click(function() {
   $('#div_216').show();
    $('#216_426_721').show();
     $('#216_426_722').show();
     $('#714_425').hide();
     $('#714').hide();
     $('#714').val('');
     $('#radio_721').removeAttr('checked');
     $('#radio_722').removeAttr('checked');

});

$('#radio_590').click(function() {
  if (violence_perpetrator_menu_items_invisibility()){
    clear_perpetrator_html_attributes();
    hide_domestic_perpetrator_menu_items();
  }else{
    show_domestic_violence_perpetrator_menu_items();
  }
});

$('#radio_592').click(function() {
  if (violence_perpetrator_menu_items_invisibility()){
    clear_perpetrator_html_attributes();
    hide_domestic_perpetrator_menu_items();
  }else{
    show_domestic_violence_perpetrator_menu_items();
  }
});

$('#radio_594').click(function() {
  if (violence_perpetrator_menu_items_invisibility()){
    clear_perpetrator_html_attributes();
    hide_domestic_perpetrator_menu_items();
    }else{
    show_domestic_violence_perpetrator_menu_items();
  }
});

$('#radio_596').click(function() {
  if (violence_perpetrator_menu_items_invisibility()){
    clear_perpetrator_html_attributes();
    hide_domestic_perpetrator_menu_items();
  }else{
    show_domestic_violence_perpetrator_menu_items();
  }
});

function violence_perpetrator_menu_items_invisibility(){
   result =$('#radio_590').is(':checked') && $('#radio_592').is(':checked') && $('#radio_594').is(':checked') && $('#radio_596').is(':checked')
  return result;
}

$('#radio_589').click(function() {

    show_domestic_violence_perpetrator_menu_items();

});

$('#radio_591').click(function() {

    show_domestic_violence_perpetrator_menu_items();

});

$('#radio_593').click(function() {

    show_domestic_violence_perpetrator_menu_items();

});

$('#radio_595').click(function() {

    show_domestic_violence_perpetrator_menu_items();
});



function clear_perpetrator_html_attributes(){
  $('#715').val('');
  $('#716').val('');
  $('#radio_668').removeAttr('checked');
  $('#radio_669').removeAttr('checked');
  $('#radio_670').removeAttr('checked');
  $('#radio_671').removeAttr('checked');
  $('#radio_672').removeAttr('checked');
  $('#radio_673').removeAttr('checked');
  $('#radio_674').removeAttr('checked');
  $('#radio_675').removeAttr('checked');
  $('#radio_676').removeAttr('checked');
  $('#radio_677').removeAttr('checked');
  $('#radio_678').removeAttr('checked');
  $('#radio_679').removeAttr('checked');
  $('#radio_680').removeAttr('checked');
  $('#radio_681').removeAttr('checked');
  $('#radio_682').removeAttr('checked');
  $('#radio_683').removeAttr('checked');
  $('#radio_684').removeAttr('checked');
  $('#radio_685').removeAttr('checked');
  $('#radio_686').removeAttr('checked');
  $('#radio_687').removeAttr('checked');
  $('#radio_688').removeAttr('checked');
  $('#radio_689').removeAttr('checked');
  $('#radio_690').removeAttr('checked');
  $('#radio_691').removeAttr('checked');
  $('#radio_692').removeAttr('checked');
  $('#radio_693').removeAttr('checked');
  $('#radio_694').removeAttr('checked');
  $('#radio_695').removeAttr('checked');
  $('#radio_696').removeAttr('checked');
  $('#radio_697').removeAttr('checked');
  $('#radio_698').removeAttr('checked');
  $('#radio_699').removeAttr('checked');
  $('#radio_700').removeAttr('checked');
  $('#radio_701').removeAttr('checked');
  $('#radio_702').removeAttr('checked');
  $('#radio_703').removeAttr('checked');
  $('#radio_704').removeAttr('checked');
  $('#radio_705').removeAttr('checked');
  $('#radio_706').removeAttr('checked');
  $('#radio_707').removeAttr('checked');
  $('#radio_708').removeAttr('checked');
  $('#radio_709').removeAttr('checked');
  $('#radio_710').removeAttr('checked');
  $('#radio_711').removeAttr('checked');
  $('#radio_712').removeAttr('checked');
  $('#radio_713').removeAttr('checked');
  $('#radio_714').removeAttr('checked');
  $('#radio_715').removeAttr('checked');
  $('#radio_716').removeAttr('checked');
  $('#radio_717').removeAttr('checked');
  $('#radio_718').removeAttr('checked');
  $('#radio_719').removeAttr('checked');
  $('#radio_720').removeAttr('checked');
  $('#714_425').removeAttr('checked');
  $('#714').removeAttr('checked');
  $('#div_216').removeAttr('checked');
  $('#216_426_721').removeAttr('checked');
  $('#216_426_722').removeAttr('checked');

}