Waves.displayEffect();
$('.modal-trigger').leanModal();
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