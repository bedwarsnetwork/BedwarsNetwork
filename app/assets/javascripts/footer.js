$(document).on('turbolinks:load', function() {
  Waves.displayEffect();
  Materialize.updateTextFields();
});
$('.collapsible').collapsible();
$('.parallax').parallax();
$('ul.tabs').tabs();
$('select').material_select();
$('.dropdown-button').dropdown();
$('.materialboxed').materialbox();
$('.button-collapse.mobile-nav').sideNav();
$('.button-collapse.user-nav').sideNav({
    menuWidth: 300,
    edge: 'right',
    closeOnClick: true
  }
);
$('.datepicker').pickadate();

$(document).ready(function(){
    $('.modal').modal();
  });


$.DivasCookies({
	bannerText: "Cookies helfen uns bei der Bereitstellung unserer Website. Durch die Nutzung unserer Website erklärst du dich damit einverstanden, dass wir Cookies setzen.",
	acceptButtonText: "OK",
	openEffect: "slideUp",
	openEffectDuration: 600,
	openEffectEasing: "swing",
	closeEffect: "slideDown",
	closeEffectDuration: 600,
	closeEffectEasing: "swing",
	pageReload: true,
	cookieDuration: 7
});

window.fbAsyncInit = function() {
    FB.init({
      appId      : '1832645806979603',
      xfbml      : true,
      version    : 'v2.8'
    });
    FB.AppEvents.logPageView();
  };

  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));
