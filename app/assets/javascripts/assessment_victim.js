function victim(){
	if (violence_victim_menu_items_invisibility()) {
    clear_victim_html_attributes();
    hide_domestic_violence_victim_menu_items();
  }else{
    show_domestic_violence_victim_menu_items();
  }
  // if ($('#709').is(':checked')){
  //     hide_domestic_violence_victim_menu_items();
  // }
}

// $('#605').change(function() {
//   if ($('#605').is(':checked')){
//     clear_victim_html_attributes();
//     hide_domestic_violence_victim_menu_items();
//   }else{
//     if (violence_victim_menu_items_invisibility()){
//       clear_victim_html_attributes();
//       hide_domestic_violence_victim_menu_items();
//     }else {
//       show_domestic_violence_victim_menu_items();
//     }
//   }
// });

// $('#709').change(function() {
//   if ($('#709').is(':checked')){
//     clear_victim_html_attributes();
//     hide_domestic_violence_victim_menu_items();
//   }else{
//     if (violence_victim_menu_items_invisibility()){
//       clear_victim_html_attributes();
//       hide_domestic_violence_victim_menu_items();
//     }else {
//       show_domestic_violence_victim_menu_items();
//     }
//   }
// });

function hide_domestic_violence_victim_menu_items(){
  $('#842_328').hide();
  $('#841_329').hide();
  $('#table_708').hide();
  $('#table_606').hide();
  $('#193_332').hide();
  $('#div_843').hide();
  $('#843_333_597').hide();
  $('#843_333_598').hide();
  $('#div_206').hide();
  $('#206_334_599').hide();
  $('#206_334_600').hide();
  $('#194_335').hide();
  $('#div_844').hide();
  $('#844_336_601').hide();
  $('#844_336_602').hide();
  $('#div_207').hide();
  $('#207_337_603').hide();
  $('#207_337_604').hide();
  $('#195_338').hide();
  $('#div_845').hide();
  $('#845_339_605').hide();
  $('#845_339_606').hide();
  $('#div_208').hide();
  $('#208_340_607').hide();
  $('#208_340_608').hide();
  $('#196_341').hide();
  $('#div_846').hide();
  $('#846_342_609').hide();
  $('#846_342_610').hide();
  $('#div_209').hide();
  $('#209_343_611').hide();
  $('#209_343_612').hide();
  $('#711_344').hide();
  $('#div_847').hide();
  $('#847_345_613').hide();
  $('#847_345_614').hide();
  $('#div_712').hide();
  $('#712_346_615').hide();
  $('#712_346_616').hide();
  $('#197_347').hide();
  $('#div_848').hide();
  $('#848_348_617').hide();
  $('#848_348_618').hide();
  $('#div_210').hide();
  $('#210_349_619').hide();
  $('#210_349_620').hide();
  $('#198_350').hide();
  $('#div_849').hide();
  $('#849_351_621').hide();
  $('#849_351_622').hide();
  $('#div_211').hide();
  $('#211_352_623').hide();
  $('#211_352_624').hide();
  $('#199_353').hide();
  $('#div_850').hide();
  $('#850_354_625').hide();
  $('#850_354_626').hide();
  $('#div_538').hide();
  $('#538_355_627').hide();
  $('#538_355_628').hide();
  $('#200_356').hide();
  $('#div_851').hide();
  $('#851_357_629').hide();
  $('#851_357_630').hide();
  $('#div_213').hide();
  $('#213_358_631').hide();
  $('#213_358_632').hide();
  $('#201_359').hide();
  $('#div_852').hide();
  $('#852_360_633').hide();
  $('#852_360_634').hide();
  $('#div_214').hide();
  $('#214_361_635').hide();
  $('#214_361_636').hide();
  $('#202_362').hide();
  $('#div_853').hide();
  $('#853_363_637').hide();
  $('#853_363_638').hide();
  $('#div_215').hide();
  $('#215_364_639').hide();
  $('#215_364_640').hide();
  $('#204_365').hide();
  $('#div_854').hide();
  $('#854_366_641').hide();
  $('#854_366_642').hide();
  $('#div_217').hide();
  $('#217_367_643').hide();
  $('#217_367_644').hide();
  $('#205_368').hide();
  $('#div_855').hide();
  $('#855_369_645').hide();
  $('#855_369_646').hide();
  $('#div_218').hide();
  $('#218_370_647').hide();
  $('#218_370_648').hide();
  $('#537_371').hide();
  $('#div_856').hide();
  $('#856_372_649').hide();
  $('#856_372_650').hide();
  $('#div_212').hide();
  $('#212_373_651').hide();
  $('#212_373_652').hide();
  $('#div_212').hide();
  $('#212_373_651').hide();
  $('#212_373_652').hide();
  $('#div_203').hide();
  $('#203_374_653').hide();
  $('#203_374_654').hide();
  $('#div_520').hide();
  $('#520_375_655').hide();
  $('#520_375_656').hide();
  $('#521_376').hide();
  $('#521').hide();
  $('#div_248').hide();
  $('#248_377_657').hide();
  $('#248_377_658').hide();
  $('#div_857').hide();
  $('#857_378_659').hide();
  $('#857_378_660').hide();
  $('#div_858').hide();
  $('#858_379_661').hide();
  $('#858_379_662').hide();
  $('#div_859').hide();
  $('#859_380_663').hide();
  $('#859_380_664').hide();
  $('#div_860').hide();
  $('#860_381_665').hide();
  $('#860_381_666').hide();
}

function show_domestic_violence_victim_menu_items(){
  $('#842_328').show();
  $('#841_329').show();
  $('#table_708').show();
  $('#table_606').show();
  $('#193_332').show();
  $('#div_843').show();
  $('#843_333_597').show();
  $('#843_333_598').show();
  if ($('#radio_597').is(':checked')){
    $('#div_206').show();
    $('#206_334_599').show();
    $('#206_334_600').show();
  }else {
    $('#div_206').hide();
    $('#206_334_599').hide();
    $('#206_334_600').hide();
  }
  $('#194_335').show();
  $('#div_844').show();
  $('#844_336_601').show();
  $('#844_336_602').show();
  if ($('#radio_601').is(':checked')){
    $('#div_207').show();
    $('#207_337_603').show();
    $('#207_337_604').show();
  }else {
    $('#div_207').hide();
    $('#207_337_603').hide();
    $('#207_337_604').hide();
  }
  $('#195_338').show();
  $('#div_845').show();
  $('#845_339_605').show();
  $('#845_339_606').show();
  if ($('#radio_605').is(':checked')){
    $('#div_208').show();
    $('#208_340_607').show();
    $('#208_340_608').show();
  }else {
    $('#div_208').hide();
    $('#208_340_607').hide();
    $('#208_340_608').hide();
  }
  $('#196_341').show();
  $('#div_846').show();
  $('#846_342_609').show();
  $('#846_342_610').show();
  if ($('#radio_609').is(':checked')){
    $('#div_209').show();
    $('#209_343_611').show();
    $('#209_343_612').show();
  }else {
    $('#div_209').hide();
    $('#209_343_611').hide();
    $('#209_343_612').hide();
  }
  $('#711_344').show();
  $('#div_847').show();
  $('#847_345_613').show();
  $('#847_345_614').show();
  if ($('#radio_613').is(':checked')){
    $('#div_712').show();
    $('#712_346_615').show();
    $('#712_346_616').show();
  }else {
    $('#div_712').hide();
    $('#712_346_615').hide();
    $('#712_346_616').hide();
  }
  $('#197_347').show();
  $('#div_848').show();
  $('#848_348_617').show();
  $('#848_348_618').show();
  if ($('#radio_617').is(':checked')){
    $('#div_210').show();
    $('#210_349_619').show();
    $('#210_349_620').show();
  }else {
    $('#div_210').hide();
    $('#210_349_619').hide();
    $('#210_349_620').hide();
  }
  $('#198_350').show();
  $('#div_849').show();
  $('#849_351_621').show();
  $('#849_351_622').show();
  if ($('#radio_621').is(':checked')){
    $('#div_211').show();
    $('#211_352_623').show();
    $('#211_352_624').show();
  }else {
    $('#div_211').hide();
    $('#211_352_623').hide();
    $('#211_352_624').hide();
  }

  $('#199_353').show();
  $('#div_850').show();
  $('#850_354_625').show();
  $('#850_354_626').show();
  if ($('#radio_625').is(':checked')){
    $('#div_538').show();
    $('#538_355_627').show();
    $('#538_355_628').show();
  }else {
    $('#div_538').hide();
    $('#538_355_627').hide();
    $('#538_355_628').hide();
  }
  $('#200_356').show();
  $('#div_851').show();
  $('#851_357_629').show();
  $('#851_357_630').show();
  if ($('#radio_629').is(':checked')){
    $('#div_213').show();
    $('#213_358_631').show();
    $('#213_358_632').show();
  }else {
    $('#div_213').hide();
    $('#213_358_631').hide();
    $('#213_358_632').hide();
  }
  $('#201_359').show();
  $('#div_852').show();
  $('#852_360_633').show();
  $('#852_360_634').show();
  if ($('#radio_633').is(':checked')){
    $('#div_214').show();
    $('#214_361_635').show();
    $('#214_361_636').show();
  }else {
    $('#div_214').hide();
    $('#214_361_635').hide();
    $('#214_361_636').hide();
  }
  $('#202_362').show();
  $('#div_853').show();
  $('#853_363_637').show();
  $('#853_363_638').show();
  if ($('#radio_637').is(':checked')){
    $('#div_215').show();
    $('#215_364_639').show();
    $('#215_364_640').show();
  }else {
    $('#div_215').hide();
    $('#215_364_639').hide();
    $('#215_364_640').hide();
  }
  $('#204_365').show();
  $('#div_854').show();
  $('#854_366_641').show();
  $('#854_366_642').show();
  if ($('#radio_641').is(':checked')){
    $('#div_217').show();
    $('#217_367_643').show();
    $('#217_367_644').show();
  }else {
    $('#div_217').hide();
    $('#217_367_643').hide();
    $('#217_367_644').hide();
  }
  $('#205_368').show();
  $('#div_855').show();
  $('#855_369_645').show();
  $('#855_369_646').show();
  if ($('#radio_645').is(':checked')){
    $('#div_218').show();
    $('#218_370_647').show();
    $('#218_370_648').show();
  }else {
    $('#div_218').hide();
    $('#218_370_647').hide();
    $('#218_370_648').hide();
  }
  $('#537_371').show();
  $('#div_856').show();
  $('#856_372_649').show();
  $('#856_372_650').show();
  if ($('#radio_649').is(':checked')){
    $('#div_212').show();
    $('#212_373_651').show();
    $('#212_373_652').show();
  }else {
    $('#div_212').hide();
    $('#212_373_651').hide();
    $('#212_373_652').hide();
  }

  $('#div_203').show();
  $('#203_374_653').show();
  $('#203_374_654').show();
  $('#div_520').show();
  $('#520_375_655').show();
  $('#520_375_656').show();
  if ($('#radio_655').is(':checked')){
    $('#521_376').show();
    $('#521').show();
  }else {
    $('#521_376').hide();
    $('#521').hide();
  }
  $('#div_248').show();
  $('#248_377_657').show();
  $('#248_377_658').show();
  $('#div_857').show();
  $('#857_378_659').show();
  $('#857_378_660').show();
  if ($('#radio_659').is(':checked')){
    $('#div_858').show();
    $('#858_379_661').show();
    $('#858_379_662').show();
  }else {
    $('#div_858').hide();
    $('#858_379_661').hide();
    $('#858_379_662').hide();
  }
  $('#div_859').show();
  $('#859_380_663').show();
  $('#859_380_664').show();
  if ($('#radio_664').is(':checked')){
    $('#div_860').show();
    $('#860_381_665').show();
    $('#860_381_666').show();
  }else {
    $('#div_860').hide();
    $('#860_381_665').hide();
    $('#860_381_666').hide();
  }
}


  $('#radio_597').click(function() {
    $('#div_206').show();
    $('#206_334_599').show();
    $('#206_334_600').show();
  });

  $('#radio_598').click(function() {
    $('#div_206').hide();
    $('#radio_599').removeAttr('checked');
    $('#radio_600').removeAttr('checked');
    $('#206_334_599').hide();
    $('#206_334_600').hide();
  });

  $('#radio_601').click(function() {
    $('#div_207').show();
    $('#207_337_603').show();
    $('#207_337_604').show();
  });

  $('#radio_602').click(function() {
    $('#div_207').hide();
    $('#radio_603').removeAttr('checked');
    $('#radio_604').removeAttr('checked');
    $('#207_337_603').hide();
    $('#207_337_604').hide();
  });

  $('#radio_605').click(function() {
    $('#div_208').show();
    $('#208_340_607').show();
    $('#208_340_608').show();
  });

  $('#radio_606').click(function() {
    $('#div_208').hide();
    $('#radio_607').removeAttr('checked');
    $('#radio_608').removeAttr('checked');
    $('#208_340_607').hide();
    $('#208_340_608').hide();
  });

  $('#radio_609').click(function() {
    $('#div_209').show();
    $('#209_343_611').show();
    $('#209_343_612').show();
  });

  $('#radio_610').click(function() {
    $('#div_209').hide();
    $('#radio_611').removeAttr('checked');
    $('#radio_612').removeAttr('checked');
    $('#209_343_611').hide();
    $('#209_343_612').hide();
  });

  $('#radio_613').click(function() {
    $('#div_712').show();
    $('#712_346_615').show();
    $('#712_346_616').show();
  });

  $('#radio_614').click(function() {
    $('#div_712').hide();
    $('#radio_615').removeAttr('checked');
    $('#radio_616').removeAttr('checked');
    $('#712_346_615').hide();
    $('#712_346_616').hide();
  });

  $('#radio_617').click(function() {
    $('#div_210').show();
    $('#210_349_619').show();
    $('#210_349_620').show();
  });

  $('#radio_618').click(function() {
    $('#div_210').hide();
    $('#radio_619').removeAttr('checked');
    $('#radio_620').removeAttr('checked');
    $('#210_349_619').hide();
    $('#210_349_620').hide();
  });

  $('#radio_621').click(function() {
    $('#div_211').show();
    $('#211_352_623').show();
    $('#211_352_624').show();
  });

  $('#radio_622').click(function() {
    $('#div_211').hide();
    $('#radio_623').removeAttr('checked');
    $('#radio_624').removeAttr('checked');
    $('#211_352_623').hide();
    $('#211_352_624').hide();
  });

  $('#radio_625').click(function() {
    $('#div_538').show();
    $('#538_355_627').show();
    $('#538_355_628').show();
  });

  $('#radio_626').click(function() {
    $('#div_538').hide();
    $('#radio_627').removeAttr('checked');
    $('#radio_628').removeAttr('checked');
    $('#538_355_627').hide();
    $('#538_355_628').hide();
  });

  $('#radio_629').click(function() {
    $('#div_213').show();
    $('#213_358_631').show();
    $('#213_358_632').show();
  });

  $('#radio_630').click(function() {
    $('#div_213').hide();
    $('#radio_631').removeAttr('checked');
    $('#radio_632').removeAttr('checked');
    $('#213_358_631').hide();
    $('#213_358_632').hide();
  });

  $('#radio_633').click(function() {
    $('#div_214').show();
    $('#214_361_635').show();
    $('#214_361_636').show();
  });

  $('#radio_634').click(function() {
    $('#div_214').hide();
    $('#radio_635').removeAttr('checked');
    $('#radio_636').removeAttr('checked');
    $('#214_361_635').hide();
    $('#214_361_636').hide();
  });

  $('#radio_637').click(function() {
    $('#div_215').show();
    $('#215_364_639').show();
    $('#215_364_640').show();
  });

  $('#radio_638').click(function() {
    $('#div_215').hide();
    $('#radio_639').removeAttr('checked');
    $('#radio_640').removeAttr('checked');
    $('#215_364_639').hide();
    $('#215_364_640').hide();
  });


  $('#radio_641').click(function() {
    $('#div_217').show();
    $('#217_367_643').show();
    $('#217_367_644').show();
  });

  $('#radio_642').click(function() {
    $('#div_217').hide();
    $('#radio_643').removeAttr('checked');
    $('#radio_644').removeAttr('checked');
    $('#217_367_643').hide();
    $('#217_367_644').hide();
  });

  $('#radio_645').click(function() {
    $('#div_218').show();
    $('#218_370_647').show();
    $('#218_370_648').show();
  });

  $('#radio_646').click(function() {
    $('#div_218').hide();
    $('#radio_647').removeAttr('checked');
    $('#radio_648').removeAttr('checked');
    $('#218_370_647').hide();
    $('#218_370_648').hide();
  });

  $('#radio_649').click(function() {
    $('#div_212').show();
    $('#212_373_651').show();
    $('#212_373_652').show();
  });

  $('#radio_650').click(function() {
    $('#div_212').hide();
    $('#radio_651').removeAttr('checked');
    $('#radio_652').removeAttr('checked');
    $('#212_373_651').hide();
    $('#212_373_652').hide();
  });

  $('#radio_655').click(function() {
    $('#521_376').show();
    $('#521').show();
  });

  $('#radio_656').click(function() {
    $('#521_376').hide();
    $('#521').val('');
    $('#521').hide();
  });

  $('#radio_659').click(function() {
    $('#div_858').show();
    $('#858_379_661').show();
    $('#858_379_662').show();
  });

  $('#radio_660').click(function() {
    $('#div_858').hide();
    $('#radio_661').removeAttr('checked');
    $('#radio_662').removeAttr('checked');
    $('#858_379_661').hide();
    $('#858_379_662').hide();
  });

  $('#radio_663').click(function() {
    $('#div_860').hide();
    $('#radio_665').removeAttr('checked');
    $('#radio_666').removeAttr('checked');
    $('#860_381_665').hide();
    $('#860_381_666').hide();
  });

  $('#radio_664').click(function() {
    $('#div_860').show();
    $('#860_381_665').show();
    $('#860_381_666').show();
  });


$('#radio_582').click(function() {
  if (violence_victim_menu_items_invisibility()) {
    clear_victim_html_attributes();
    hide_domestic_violence_victim_menu_items();
  }else{
    show_domestic_violence_victim_menu_items();
  }
});

$('#radio_584').click(function() {
  if (violence_victim_menu_items_invisibility()) {
    clear_victim_html_attributes();
    hide_domestic_violence_victim_menu_items();
  }else{
    show_domestic_violence_victim_menu_items();
  }
});

$('#radio_586').click(function() {
  if (violence_victim_menu_items_invisibility()) {
    clear_victim_html_attributes();
    hide_domestic_violence_victim_menu_items();
  }
});

$('#radio_588').click(function() {
  if (violence_victim_menu_items_invisibility()) {
    clear_victim_html_attributes();
    hide_domestic_violence_victim_menu_items();
  }else{
    show_domestic_violence_victim_menu_items();
  }
});


// $('#radio_590').click(function() {
//   if (violence_victim_menu_items_invisibility() || $('#605').is(':checked') || $('#709').is(':checked')){
//     clear_victim_html_attributes();
//     hide_domestic_violence_victim_menu_items();
//   }else{
//     show_domestic_violence_victim_menu_items();
//   }
// });

// $('#radio_592').click(function() {
//   if (violence_victim_menu_items_invisibility() || $('#605').is(':checked') || $('#709').is(':checked')){
//     clear_victim_html_attributes();
//     hide_domestic_violence_victim_menu_items();
//   }else{
//     show_domestic_violence_victim_menu_items();
//   }
// });

// $('#radio_594').click(function() {
//   if (violence_victim_menu_items_invisibility() || $('#605').is(':checked') || $('#709').is(':checked')){
//     clear_victim_html_attributes();
//     hide_domestic_violence_victim_menu_items();
//   }
// });

// $('#radio_596').click(function() {
//   if (violence_victim_menu_items_invisibility() || $('#605').is(':checked') || $('#709').is(':checked')){
//     clear_victim_html_attributes();
//     hide_domestic_violence_victim_menu_items();
//   }else{
//     show_domestic_violence_victim_menu_items();
//   }
// });

function violence_victim_menu_items_invisibility(){
  result =  $('#radio_582').is(':checked') && $('#radio_584').is(':checked') && $('#radio_586').is(':checked') && $('#radio_588').is(':checked')
  // result = result && $('#radio_590').is(':checked') && $('#radio_592').is(':checked') && $('#radio_594').is(':checked') && $('#radio_596').is(':checked')
  return result;
}

$('#radio_581').click(function() {

    show_domestic_violence_victim_menu_items();

});


$('#radio_583').click(function() {

    show_domestic_violence_victim_menu_items();

});

$('#radio_585').click(function() {

    show_domestic_violence_victim_menu_items();

});

$('#radio_587').click(function() {

    show_domestic_violence_victim_menu_items();

});

// $('#radio_589').click(function() {
//   if ($('#605').is(":not(':checked')") && $('#709').is(":not(':checked')")){
//     show_domestic_violence_victim_menu_items();
//   }else{
//     clear_victim_html_attributes();
//     hide_domestic_violence_victim_menu_items();
//   }
// });

// $('#radio_591').click(function() {
//   if ($('#605').is(":not(':checked')") && $('#709').is(":not(':checked')")){
//     show_domestic_violence_victim_menu_items();
//   }else{
//     clear_victim_html_attributes();
//     hide_domestic_violence_victim_menu_items();
//   }
// });

// $('#radio_593').click(function() {
//   if ($('#605').is(":not(':checked')") && $('#709').is(":not(':checked')")){
//     show_domestic_violence_victim_menu_items();
//   }else{
//     clear_victim_html_attributes();
//     hide_domestic_violence_victim_menu_items();
//   }
// });

// $('#radio_595').click(function() {
//   if ($('#605').is(":not(':checked')") && $('#709').is(":not(':checked')")){
//     show_domestic_violence_victim_menu_items();
//   }else{
//     clear_victim_html_attributes();
//     hide_domestic_violence_victim_menu_items();
//   }
// });

function clear_victim_html_attributes(){
  $('#708').val('');
  $('#606').val('');
  $('#radio_597').removeAttr('checked');
  $('#radio_598').removeAttr('checked');
  $('#radio_599').removeAttr('checked');
  $('#radio_600').removeAttr('checked');
  $('#radio_601').removeAttr('checked');
  $('#radio_602').removeAttr('checked');
  $('#radio_603').removeAttr('checked');
  $('#radio_604').removeAttr('checked');
  $('#radio_605').removeAttr('checked');
  $('#radio_606').removeAttr('checked');
  $('#radio_607').removeAttr('checked');
  $('#radio_608').removeAttr('checked');
  $('#radio_609').removeAttr('checked');
  $('#radio_610').removeAttr('checked');
  $('#radio_611').removeAttr('checked');
  $('#radio_612').removeAttr('checked');
  $('#radio_613').removeAttr('checked');
  $('#radio_614').removeAttr('checked');
  $('#radio_615').removeAttr('checked');
  $('#radio_616').removeAttr('checked');
  $('#radio_617').removeAttr('checked');
  $('#radio_618').removeAttr('checked');
  $('#radio_619').removeAttr('checked');
  $('#radio_620').removeAttr('checked');
  $('#radio_621').removeAttr('checked');
  $('#radio_622').removeAttr('checked');
  $('#radio_623').removeAttr('checked');
  $('#radio_624').removeAttr('checked');
  $('#radio_625').removeAttr('checked');
  $('#radio_626').removeAttr('checked');
  $('#radio_627').removeAttr('checked');
  $('#radio_628').removeAttr('checked');
  $('#radio_629').removeAttr('checked');
  $('#radio_630').removeAttr('checked');
  $('#radio_631').removeAttr('checked');
  $('#radio_632').removeAttr('checked');
  $('#radio_633').removeAttr('checked');
  $('#radio_634').removeAttr('checked');
  $('#radio_635').removeAttr('checked');
  $('#radio_636').removeAttr('checked');
  $('#radio_637').removeAttr('checked');
  $('#radio_638').removeAttr('checked');
  $('#radio_639').removeAttr('checked');
  $('#radio_640').removeAttr('checked');
  $('#radio_641').removeAttr('checked');
  $('#radio_642').removeAttr('checked');
  $('#radio_643').removeAttr('checked');
  $('#radio_644').removeAttr('checked');
  $('#radio_645').removeAttr('checked');
  $('#radio_646').removeAttr('checked');
  $('#radio_647').removeAttr('checked');
  $('#radio_648').removeAttr('checked');
  $('#radio_649').removeAttr('checked');
  $('#radio_650').removeAttr('checked');
  $('#radio_651').removeAttr('checked');
  $('#radio_652').removeAttr('checked');
  $('#radio_653').removeAttr('checked');
  $('#radio_654').removeAttr('checked');
  $('#radio_655').removeAttr('checked');
  $('#radio_656').removeAttr('checked');
  $('#521').val('');
  $('#radio_657').removeAttr('checked');
  $('#radio_658').removeAttr('checked');
  $('#radio_659').removeAttr('checked');
  $('#radio_660').removeAttr('checked');
  $('#radio_661').removeAttr('checked');
  $('#radio_662').removeAttr('checked');
  $('#radio_663').removeAttr('checked');
  $('#radio_664').removeAttr('checked');
  $('#radio_665').removeAttr('checked');
  $('#radio_666').removeAttr('checked');
}