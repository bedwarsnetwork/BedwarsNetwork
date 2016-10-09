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
  
  $('table.paginated').each(function() {
      var currentPage = 1;
      var numPerPage = 5;
      var $table = $(this);
      var $pager = $table.next(".pager").find('.card-action-btn');
      var numRows = $table.find('tbody tr').length;
      var numPages = Math.ceil(numRows / numPerPage);
      
      $table.bind('repaginate', function(event, page) {
        $table.find('tbody tr').hide().slice((page - 1) * numPerPage, page * numPerPage).show();
        currentPage = page;
      });
      $pager.find('a.page-number').on('click', function(event) {
        var newPage = currentPage;
        if($(this).hasClass('forward') && currentPage < numPages){
            newPage = newPage + 1;
            $table.trigger('repaginate', [newPage]);
        }
        if($(this).hasClass('back') && currentPage > 1){
            newPage = newPage - 1;
            $table.trigger('repaginate', [newPage]);
        };
        if(newPage > 1 && newPage < numPages){
          $pager.find('.back').removeClass('disabled');
          $pager.find('.forward').removeClass('disabled');
        } else if(newPage == 1 && newPage < numPages) {
          $pager.find('.back').addClass('disabled');
          $pager.find('.forward').removeClass('disabled');
        } else if(newPage > 1 && newPage == numPages) {
          $pager.find('.back').removeClass('disabled');
          $pager.find('.forward').addClass('disabled');
        } else {
          $pager.find('.back').addClass('disabled');
          $pager.find('.forward').addClass('disabled');
        }
      });
      $table.trigger('repaginate', [1]);
    });
});

$('tr[data-href]').on("click", function() {
  document.location = $(this).data('href');
});
$('tr[data-href]').hover(function() {
  $(this).css('cursor','pointer');
}, function() {
  $(this).css('cursor','');
});