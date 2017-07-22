// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require gmaps/google
//= require_tree .

$(function(){ $(document).foundation(); });

document.addEventListener("DOMContentLoaded", function() {
    var elements = document.getElementsByTagName("INPUT");
    for (var i = 0; i < elements.length; i++) {
        elements[i].oninvalid = function(e) {
            e.target.setCustomValidity("");
            if (!e.target.validity.valid) {
            	e.target.setCustomValidity("Please enter "+e.target.alt)
            }
        };
        elements[i].oninput = function(e) {
            e.target.setCustomValidity("");
        };
    }
})



//JS for side menu to show submenu
$('#side-nav > ul > li > a').click(function() {
  $('#side-nav li').removeClass('active');
  $(this).closest('li').addClass('active');
  var checkElement = $(this).next();
  if((checkElement.is('ul')) && (checkElement.is(':visible'))) {
    $(this).closest('li').removeClass('active');
    checkElement.slideUp('normal');
  }
  if((checkElement.is('ul')) && (!checkElement.is(':visible'))) {
    $('#side-nav ul ul:visible').slideUp('normal');
    checkElement.slideDown('normal');
  }
  if($(this).closest('li').find('ul').children().length == 0) {
    return true;
  } else {
    return false;
  }
});




//JS related to allow only numbers to key in
//use onkeypress: "return isNumberKey(event)" in HTML page of the input field
function isNumberKey(evt){
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}

// Manoj Patil 01/06/2014
// Description: Makes the Div visible/Invisible.
// Usage:


//  Div that needs to visible/invisible
// <div id="srvc_line_items_toggle"  style="display: none">
// <%= render  "common_service_authorization_line_items" %>
// </div>

//  Link that will call Java script to make visible/invisible
// <%= link_to "Service Line Items","#",id: "hyperlink",onclick:"toggle_visibility('srvc_line_items_toggle')" %>

 function toggle_visibility(id){
    var e = document.getElementById(id);
    if(e.style.display == 'none')
      e.style.display = 'block';
    else
      e.style.display = 'none';
  }



function isNaturalNumber(evt){
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode <= 48 || charCode > 57))
        return false || (evt.srcElement.value.length > 0 && charCode == 48);
      return true;
}


//JS to restrict the text field entry to numbers and single dot.  - Kiran 07/31/2014
function isDecimal(evt){
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57))
      if(charCode == 46){
        if(evt.srcElement.value.split('.').length>1)
          return false;
        else
          return true;
      }
      else
        return false;
    return true;
}

function isCurrency(evt) {
    var keyCode = evt.keyCode ? evt.keyCode : ((evt.charCode) ? evt.charCode : evt.which);
    if (!(keyCode >= 48 && keyCode <= 57)) {
        if (!(keyCode == 8 || keyCode == 9 || keyCode == 35 || keyCode == 36 || keyCode == 37 || keyCode == 39 || keyCode == 46)) {
            return false;
        }
        else {
            return true;
        }
    }

    var velement = evt.target || evt.srcElement

    var RE = /^\d{0,7}(\.{1}\d{0,2})?$/
    return RE.test(velement.value)
}

function allow_only_numbers_5_digits_2_decimals(evt) {
    var keyCode = evt.keyCode ? evt.keyCode : ((evt.charCode) ? evt.charCode : evt.which);
    if (!(keyCode >= 48 && keyCode <= 57)) {
        if (!(keyCode == 8 || keyCode == 9 || keyCode == 35 || keyCode == 36 || keyCode == 37 || keyCode == 39 || keyCode == 46)) {
            return false;
        }
        else {
            return true;
        }
    }

    var velement = evt.target || evt.srcElement

    var RE = /^\d{0,3}(\.{1}\d{0,2})?$/
    return RE.test(velement.value)
}

function setDecimalValue_3_digits_2_decimals(evt) {
  var velement = evt.target || evt.srcElement
  if(velement.value.indexOf('.')!=-1){
      if(velement.value.split(".")[1].length > 2){
          if( isNaN( parseFloat( velement.value ) ) ) return;
          velement.value = parseFloat(velement.value).toFixed(2);
      }
  } else{
    if (velement.value.length > 3) {
      velement.value = parseFloat(velement.value.toString().substr(0, 3))
    }
  }
    var parts = velement.value.split('.');
    if (parts[0].length > 3) {
      velement.value = parseFloat(parts[0].substr(0, 3) + '.' + parts[1])
    }
}








// function validate_date_format(evt) {
//   var date = evt.target || evt.srcElement
//   if (date.value == "") {
//     return true
//   } else{
//     year = date.value.split("-")[0]
//     if (year.length == 4 && (year.charAt(0) == "0")) {
//       return true
//     } else{
//       return false
//     };

//   };
// }


function validate_date_format(evt) {
  var date = evt.target || evt.srcElement
  year = date.value.split("-")[0]
  if (year.length > 4 ) {
    date.value = date.value.split("-")[0].substr(year.length - 4, year.length) + "-" + date.value.split("-")[1] + "-" + date.value.split("-")[2]
  }

}

function setDecimalValue(evt) {
  var velement = evt.target || evt.srcElement
  if(velement.value.indexOf('.')!=-1){
      if(velement.value.split(".")[1].length > 2){
          if( isNaN( parseFloat( velement.value ) ) ) return;
          velement.value = parseFloat(velement.value).toFixed(2);
      }
  } else{
    if (velement.value.length > 6) {
      velement.value = parseFloat(velement.value.toString().substr(0, 6))
    }
  }
    var parts = velement.value.split('.');
    if (parts[0].length > 6) {
      velement.value = parseFloat(parts[0].substr(0, 6) + '.' + parts[1])
    }
}

function ispercentage(evt) {
    var keyCode = evt.keyCode ? evt.keyCode : ((evt.charCode) ? evt.charCode : evt.which);
    if (!(keyCode >= 48 && keyCode <= 57)) {
        if (!(keyCode == 8 || keyCode == 9 || keyCode == 35 || keyCode == 36 || keyCode == 37 || keyCode == 39 || keyCode == 46)) {
            return false;
        }
        else {
            return true;
        }
    }

    var velement = evt.target || evt.srcElement
    var fstpart_val = velement.value;
    var fstpart = velement.value.length;
    if (fstpart .length == 2) return false;
    var parts = velement.value.split('.');
    if (parts[0].length >= 5) return false;
    if (parts.length == 2 && parts[1].length >= 2) return false;
}









//JS related to allow only alphabets to key in
//use onKeyPress: "return onlyAlphabets(event,this)" in HTML page of the input field just allows alphabets
function onlyAlphabets(e, t) {
            try {
                if (window.event) {
                    var charCode = window.event.keyCode;
                }
                else if (e) {
                    var charCode = e.which;
                }
                else { return true; }
                if ((charCode > 64 && charCode < 91) || (charCode > 96 && charCode < 123))
                    return true;
                else
                    return false;
            }
            catch (err) {
                alert(err.Description);
            }
        }

        //function added to set the border color of dropdown menus - Kiran 09/02/2014

        $(function () {
            $("select").each(function () {
                $(this).addClass("blur");
                $(this).focus(function () {
                    $(this).removeClass("dropdown-blur").addClass("dropdown-focus");
                });
                $(this).blur(function () {
                    $(this).removeClass("dropdown-focus").addClass("dropdown-blur");
                });
            });
        });

         // Changes done for ssn and phone number formatting - Kiran 10/10/2014
		 // $(function () {
   //          $("phones__number").each(function () {
   //              $(this).mask("(999) 999-9999");
   //          });
   //      });

        jQuery(function($){
   $("#primary_Primary").mask("(999) 999-9999");
   $("#secondary_Secondary").mask("(999) 999-9999");
   $("#other_Other").mask("(999) 999-9999");
   $("#date").mask("99/99/9999");
   $("#phone").mask("(999) 999-9999");
   $("#home_phone").mask("(999) 999-9999");
   $("#tin").mask("99-9999999");
   $("#ssn").mask("999-99-9999");
   $("#client_ssn").mask("999-99-9999");
   $("#federal_ein").mask("99-9999999");
   $("#state_ein").mask("99-9999999");
   $("#prescreen_household_phone").mask("(999) 999-9999");
   $("#expense_creditor_phone").mask("(999) 999-9999");
   $("#employment_employer_phone").mask("(999) 999-9999");
   $("#user_phone_number").mask("(999) 999-9999");

});


 // Changes done for ssn and phone number formatting - Kiran 10/10/2014 end


// $(document).ready(function(){
//           $('input').click(function(){
//             $('input:checked').parent().removeClass("radio-button").addClass("radio-button-focus");
//           });
//           $('input').blur(function(){
//             $('input:checked').parent().removeClass("radio-button-focus").addClass("radio-button");
//           });
//         });

// $(function () {
//             $("input:checked").each(function () {
//                 $(this).addClass("blur");
//                 $(this).focus(function () {
//                     $(this).removeClass("radio-button").addClass("radio-button-focus");
//                 });
//                 $(this).blur(function () {
//                     $(this).removeClass("radio-button-focus").addClass("radio-button");
//                 });
//             });
//         });

function allow_only_numbers_and_max_upto_two_digits(evt){
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57) || evt.srcElement.value.length > 1)
        return false;
    return true;
}


function isLimitedNaturalNumber(evt,a){
     var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57) || evt.srcElement.value.length >= a)
        return false;
    return true;
}




//date validation
var dtCh= "/";
var minYear=1900;
var maxYear=2100;

// function isInteger(s){
//   var i;
//     for (i = 0; i < s.length; i++){
//         // Check that current character is number.
//         var c = s.charAt(i);
//         if (((c < "0") || (c > "9"))) return false;
//     }
//     // All characters are numbers.
//     return true;
// }

// function stripCharsInBag(s, bag){
//   var i;
//     var returnString = "";
//     // Search through string's characters one by one.
//     // If character is not in bag, append to returnString.
//     for (i = 0; i < s.length; i++){
//         var c = s.charAt(i);
//         if (bag.indexOf(c) == -1) returnString += c;
//     }
//     return returnString;
// }

function daysInFebruary(year){
  // February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}
function DaysArray(n) {
  for (var i = 1; i <= n; i++) {
    this[i] = 31
    if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
    if (i==2) {this[i] = 29}
   }
   return this
}

// function isDate(dtStr){
//   var daysInMonth = DaysArray(12)
//   var pos1=dtStr.indexOf(dtCh)
//   var pos2=dtStr.indexOf(dtCh,pos1+1)
//   var strMonth=dtStr.substring(0,pos1)
//   var strDay=dtStr.substring(pos1+1,pos2)
//   var strYear=dtStr.substring(pos2+1)
//   strYr=strYear
//   if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
//   if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
//   for (var i = 1; i <= 3; i++) {
//     if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
//   }
//   month=parseInt(strMonth)
//   day=parseInt(strDay)
//   year=parseInt(strYr)
//   if (pos1==-1 || pos2==-1){
//     alert("The date format should be : mm/dd/yyyy")
//     return false
//   }
//   if (strMonth.length<1 || month<1 || month>12){
//     alert("Please enter a valid month")
//     return false
//   }
//   if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
//     alert("Please enter a valid day")
//     return false
//   }
//   if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
//     alert("Please enter a valid 4 digit year between "+minYear+" and "+maxYear)
//     return false
//   }
//   if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
//     alert("Please enter a valid date")
//     return false
//   }
// return true
// }

function ValidateForm(){
  var dt=document.frmSample.txtDate
  if (isDate(dt.value)==false){
    dt.focus()
    return false
  }
    return true
 }




  function calcRoute() {
    if (document.getElementById("trip_start_address") != null && document.getElementById("trip_end_address") != null) {
          var geocoder = new google.maps.Geocoder();
          var  origin, destination
          geocoder.geocode( { 'address': document.getElementById("trip_start_address").value}, function(results, status) {
              if (status == google.maps.GeocoderStatus.OK) {
                origin = results[0].geometry.location
              }
            });

          geocoder.geocode( { 'address': document.getElementById("trip_end_address").value}, function(results, status) {
              if (status == google.maps.GeocoderStatus.OK) {
                destination = results[0].geometry.location
                build_directions_map(origin, destination)
              }
            });
    };
  }

  function build_directions_map(origin, destination){
    var directionsDisplay = new google.maps.DirectionsRenderer();
    var directionsService = new google.maps.DirectionsService();
    var request = {
        origin:      origin,
        destination: destination,
        travelMode:  google.maps.TravelMode.DRIVING
    };

    directionsService.route(request, function(response, status) {
      if (status == google.maps.DirectionsStatus.OK) {
        directionsDisplay.setDirections(response);
      }

    });

    var request1 = {
        origins: [origin],
        destinations: [destination],
        travelMode: google.maps.TravelMode.DRIVING,
        unitSystem: google.maps.UnitSystem.IMPERIAL,
        avoidHighways: false,
        avoidTolls: false
    };

    var service = new google.maps.DistanceMatrixService();

    service.getDistanceMatrix(request1, function calculate_distance(response, status) {
          if (status == google.maps.DistanceMatrixStatus.OK) {
            var origins = response.originAddresses;
            var destinations = response.destinationAddresses;

            for (var i = 0; i < origins.length; i++) {
              var results = response.rows[i].elements;
              for (var j = 0; j < results.length; j++) {
                var element = results[j];
                var distance = element.distance.text;
                var duration = element.duration.text;
                var from = origins[i];
                var to = destinations[j];
                //alert("distance: "+distance)
                document.getElementById("arg_distance").value = distance
              }
            }
          }
        });




    var handler = Gmaps.build('Google');
    handler.buildMap({ internal: {id: 'directions'}}, function(){
      directionsDisplay.setMap(handler.getMap());
    });
  }



  $('select[id*="program_wizard_run_month_2i"]').wrapAll('<div class="large-6 columns">');
  $('select[id*="program_wizard_run_month_1i"]').wrapAll('<div class="large-6 columns">');
  $('select[id*="sanction_detail_sanction_month_2i"]').wrapAll('<div class="large-6 columns">');
  $('select[id*="sanction_detail_sanction_month_1i"]').wrapAll('<div class="large-6 columns">');
  $('select[id*="client_characteristic_end_date_2i"]').wrapAll('<div class="large-6 columns">');
  $('select[id*="client_characteristic_end_date_1i"]').wrapAll('<div class="large-6 columns">');
  $('select[id*="client_characteristic_start_date_2i"]').wrapAll('<div class="large-6 columns">');
  $('select[id*="client_characteristic_start_date_1i"]').wrapAll('<div class="large-6 columns">');
  $('select[id*="education_effective_end_date_2i"]').wrapAll('<div class="large-6 columns">');
  $('select[id*="education_effective_end_date_1i"]').wrapAll('<div class="large-6 columns">');
  $('select[id*="education_effective_beg_date_2i"]').wrapAll('<div class="large-6 columns">');
  $('select[id*="education_effective_beg_date_1i"]').wrapAll('<div class="large-6 columns">');
  $('select[id*="education_expected_grad_date_2i"]').wrapAll('<div class="large-6 columns">');
  $('select[id*="education_expected_grad_date_1i"]').wrapAll('<div class="large-6 columns">');



function js_comment(){


    li_participation_identification_type = document.getElementById('link_for_comments').value
    if (li_participation_identification_type == "4599" )
        document.getElementById('client_other_identification_document').style.display = 'inline';
       else
        document.getElementById('client_other_identification_document').style.display = 'none';
}

function show_feedback_message(){
      //alert("test message")
      var element = document.getElementById("subject");
      $('#arwins_feedback_msg').show();
      $('#arwins_comments_form').hide();
      element.scrollIntoView(true);
      // $('#show_arwins_comments_form').val() = true
         $('html, body').animate({
   scrollTop: $('footer').offset().top
   }, 'slow');
}

function show_feedback_form(){
  //alert("test form")
   //alert($('#show_arwins_comments_form').val())
   var element = document.getElementById("subject");
      $('#arwins_feedback_msg').hide();
      $('#arwins_comments_form').show();
      element.scrollIntoView(true);

      $('html, body').animate({
   scrollTop: $('footer').offset().top
   }, 'slow');
}

// function on_load_of_application(){
//   calcRoute();
//   if ($('#show_arwins_comments_form').val()) {
//     $('#arwins_feedback').show();
//   }else{
//     $('#arwins_feedback').hide();
//   }
// }

// function general_onloads() {
//   set_frequency_menu();
//   set_action_plan_details_outcome();
//   onload_step2();
//   set_action_plan_details_outcome();
//   set_action_plan_details_outcome();set_activity_dropdown();
//   set_action_plan_detail_extension_button();
//   set_action_plan_outcome();
//   assessment_scripts();
//   js_other_identification_document();
//   set_service_type();
//   calcRoute();
//   set_payment_amount();
//   highlight_table_fields();
// }

// Manoj Patil 03/02/2016 - start
// zurb foundation class -"disabled button" only changes color - still redirects - this will fix that issue.
$('.disabled').click(function(e){
  return false;
});

// Manoj Patil 03/02/2016 - end

