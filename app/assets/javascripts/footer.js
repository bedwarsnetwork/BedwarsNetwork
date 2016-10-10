$(document).on('turbolinks:load', function() {
  Waves.displayEffect();
  $(".button-collapse.mobile-nav").sideNav();
  $('.button-collapse.user-nav').sideNav({
      menuWidth: 300, // Default is 240
      edge: 'right', // Choose the horizontal origin
      closeOnClick: true // Closes side-nav on <a> clicks, useful for Angular/Meteor
    }
  );
  $('.modal-trigger').leanModal();
  $('.parallax').parallax();
  $('ul.tabs').tabs();
  $('select').material_select();
  $(".dropdown-button").dropdown();
  $('.materialboxed').materialbox();
  
  $.DivasCookies({
		bannerText				: "Cookies helfen uns bei der Bereitstellung unserer Website. Durch die Nutzung unserer Website erklärst du dich damit einverstanden, dass wir Cookies setzen.",		// text for the Divas Cookies banner
		acceptButtonText		: "OK",						// text for the close button
		openEffect				: "slideUp",				// opening effect for Divas Cookies banner ["fade", "slideUp", "slideDown", "slideLeft", "slideRight"]
		openEffectDuration		: 600,						// duration of the opening effect (msec)
		openEffectEasing		: "swing",					// easing for the opening effect
		closeEffect				: "slideDown",				// closing effect for Divas Cookies banner ["fade", "slideUp", "slideDown", "slideLeft", "slideRight"]
		closeEffectDuration		: 600,						// duration of the closing effect (msec)
		closeEffectEasing		: "swing",					// easing for the closing effect
		pageReload				: true,
		cookieDuration			: 7						// number of days after which the Divas Cookie technical cookie will expire (default 365 days)
	});
 
});