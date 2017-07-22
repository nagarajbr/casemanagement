$(document).ready(function(){
    $("#notes_test").click(function(){
        $("#narative_notes").toggle();
        $("#notes_test").toggle();
         $('html, body').animate({
           scrollTop: $('#narative_notes').offset().top
           }, 'slow');
    });
    $("#cancel_narative").click(function(){
        $("#narative_notes").toggle();
        $("#notes_test").toggle();
    });
});