/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function showFlash(message) {
//    jQuery('body').prepend('<div id="flash" style="display:none"></div>');
//    jQuery('#flash').html(message);
//    jQuery('#flash').toggleClass('cssClassHere');
//    jQuery('#flash').slideDown('slow');
//    jQuery('#flash').click(function () { $('#flash').toggle('highlight') });
    $(document).ready(function() {
	var $dialog = $('<div></div>')
		.html(message)
		.dialog({
			autoOpen: true,
			title: 'Error'
		});

	$('#opener').click(function() {
		$dialog.dialog('open');
		// prevent the default action, e.g., following a link
		return false;
	});
});
}

