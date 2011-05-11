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
	
	var oldValue = '';
	
	function toMinutos(value) {
		var tiempo_base = value.split(":")
      	var horas = tiempo_base[0];
      	return Number(horas) * 60 + Number(tiempo_base[1]);
	}
	
	$('.temporizador_tiempo_base_week').keypress(function (event) {
		var otrosKeys = [0,8, 58];
		if ($.inArray(event.which, otrosKeys) == -1 && (event.which < 48 || event.which > 57) || event.which == 13) {
		  event.preventDefault();
		  return false;
      	}
	}).focusout(function(event){
		var newValue = $(this).val();

		if (oldValue !== newValue) {
			
			var minutosOld = toMinutos(oldValue);
			var minutosNew = toMinutos(newValue);
			
			var partes = $(this).getIdSplit(';');
			var fecha = partes[2];
			var filtro = partes[1].split('_');
			
			var form = $('#form-submit-edit-week form');
			form.attr('action', 'editOnWeek');
			
			form.find('input[name=fecha]').val(fecha);
			form.find('input[name=nuevo]').val(minutosNew > minutosOld);
			form.find('input[name=temporizador[proyecto_id]]').val(filtro[1]);
			form.find('input[name=temporizador[tarea_id]]').val(filtro[2]);
			form.find('input[name=tiempo_base]').val(newValue);
			
			form.submit();
		}
		
	}).focusin(function(event){
		oldValue = $(this).val();
	});
	
  });
  
})(jQuery);
