(function ($) {

  $(document).ready(function () {
	
	$('.lnk_approval_timesheet').unbind('click').click(function(event){
		
		var form = $('#form-submit-approval form');
		form.attr('action',$(this).attr('action'));
		form.submit();

		event.preventDefault();
	});
	
	$('.lnk_delete_row_week').unbind('click').click(function(event){

		var filtro = $(this).getIdSplit('-')[1].split(';');
		
		if ($.confirm('estas seguro?', function(){

			var form = $('#form-submit-week form');
			form.attr('action','deleteRowWeek');
			
			form.find('input[name=filtro[cliente_id]]').val(filtro[0])
			form.find('input[name=filtro[proyecto_id]]').val(filtro[1])
			form.find('input[name=filtro[tarea_id]]').val(filtro[2])
			
			form.submit();
		}));
				
		event.preventDefault();
	});
	
	$('#lnk_add_row_week').unbind('click').click(function(event){
		$('#addrowweek').load('/timesheet/addRowWeek').show();
		event.preventDefault();
	});
	
	$('#lnk_acept_new_row_week').unbind('click').click(function(event){
		
		var form = $('#form-submit-new-row-week form');
		form.attr('action','newRowWeek');
		
		form.submit();
		
		event.preventDefault();
	});
	
	$('#lnk_cancel_new_row_week').unbind('click').click(function(event){
		$('#addrowweek').hide();
		event.preventDefault();
	});
	
  });
  
})(jQuery);
