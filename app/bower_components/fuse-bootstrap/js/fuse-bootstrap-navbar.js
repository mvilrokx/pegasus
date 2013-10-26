// Manage the active tab (this is only useful for single page apps,
// otherwise this should get handled on the server)
$('.nav').on('click', 'li:not(.active)', function(event) {
	$(event.delegateTarget).find('.active').removeClass('active');
	$(this).addClass('active');
});

$('#myTab a').click(function (e) {
  e.preventDefault();
  $(this).tab('show');
});

// $('#myModal').modal();