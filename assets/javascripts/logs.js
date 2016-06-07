$(function() {
  $('#logs .show-metadata').click(function(e) {
    $('.metadata', $(this).closest('.log-item')).fadeToggle();
    e.preventDefault();
    return false;
  });
});
