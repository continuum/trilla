(function ($) {

	$(document).ready(function () {
	
		$('textarea.resizable:not(.processed)').TextAreaResizer();
		
		var parametros = undefined;
		var TRY_CONNECT_COUNT = 0;
		
		$('#maxrows').attr('disabled', true);
		
		var isMaxrow = $('#isMaxrows');
		isMaxrow.setChecked(false);
		
		isMaxrow.unbind('click').click(function(event){
			$('#maxrows').attr('disabled', !$(this).isChecked());
		});
		
		/**
		 * 
		 * @param {Object} event
		 */
		$('#btn-ejecutar-sql').unbind('click').click(function(event){
			
			var querys_sql = $('#querys-sql').val();
			
			if (querys_sql != undefined && !querys_sql.blank()) {
				
				var querys = querys_sql.split('}');
				
				querys_sql = '';
				
				$.each(querys, function(i, e){
					
					if (e != undefined && !e.blank()) {
						
						var sql = e.trim();
						
						if (!sql.startsWith('-') && !sql.startsWith('--') && !sql.startsWith('/') && !sql.startsWith('//')){
							
							sql = sql.replace(/{/gi,'');
							sql = sql.trim();
							
							if (sql.toLowerCase().startsWith('call ')) {
								//querys_sql+='SQL{CALL=' + toJson(generaSP_SQL(sql)) + '}SQL';
							} else {
								querys_sql+= 'SQL{' + sql + '}SQL';
							}
						}
					}
					
				});

				if (querys_sql && !querys_sql.blank()) {
					
					var params = {
						querys: querys_sql
					};
					
					if ($('#isMaxrows').isChecked()){
						params.maxrows = $('#maxrows').val();
					}
					
					$.ajaxMsgPostJSON('Ejecutando SQL','execute', params, function (json) {
						
						if (json.success) {
							
							var div = $('#resultados-sql').empty();
							
							for (var i = 0; i < json.countResults; i++) {
								var result = json['result' + i];
								$.muestraResultados(div, result);
							}
							
							bind_click_export_csv();
							bind_click_save_query_report();
	
						} else {
							$.error(json.msg);
						}
					});
				}
			} 
			
			event.preventDefault();
		});
		
		$('#link-ayuda-sql').click(function(event){
			
			$('#div-ayuda-sql').toggle();
			
			event.preventDefault();
		});
		
		/**
		 * 
		 */
		function bind_click_export_csv() {
			
			$('.export_csv').unbind('click').click(function(event){
	
				var query = $(this).attr('query');
				var maxrows = $(this).attr('maxrows');
	
				var form = $('#form-submit-reportes-csv form');
				form.find('input[name=query]').val(query)
				form.find('input[name=maxrows]').val(maxrows)
				form.submit();
						
				event.preventDefault();
			});
		}
		
		$('#div-nuevo-reporte').keyValidateByClassForm().jqm({modal: true});
		
		/**
		 * 
		 */
		function bind_click_save_query_report() {
			
			$('.save_query_report').unbind('click').click(function(event){

				var query = $(this).attr('query');

				$.ajaxPostJSON('reportes/tipos_reportes', {}, function (json) {
					if (json.success) {
						var data = new Array();
						$.each(json.tipos,function(i, e){ data[i] = e.tipo; });
						$("#reporte_tipo").autocomplete(data, {multipleSeparator:'',multiple:false});
					}	
				});

				var reporte_nombre = $('#reporte_nombre');
				reporte_nombre.val('');
				var reporte_descripcion = $('#reporte_descripcion');
				reporte_descripcion.val('');
				var reporte_tipo = $('#reporte_tipo');
				reporte_tipo.val('');

				var form = $('#div-nuevo-reporte').jqmShow();
				
				$('#lnk-guardar-reporte').unbind('click').click(function(event){
					
					form.validateForm(function(){
						
						var params = {
							'reporte[query]': query,
							'reporte[descripcion]': reporte_descripcion.val(),
							'reporte[nombre]': reporte_nombre.val(),
							'reporte[tipo]': reporte_tipo.val().toUpperCase()
						};
						
						$.ajaxMsgPostJSON('Ejecutando SQL','reportes/save_query_report', params, function (json) {
							
							if (json.success) {
								$('#div-nuevo-reporte').jqmHide();			
							} else {
								$.error(json.msg);
							}
						});
						
					}, function(errores){
						$.error(errores);
					});

					event.preventDefault();
				});
				
				$('#lnk-cancelar-reporte').unbind('click').click(function(event){
					$('#div-nuevo-reporte').jqmHide();
					event.preventDefault();
				});		
		
				event.preventDefault();
			});
			
		}
				
		/**
		 * muestra los resultados sql
		 */
		$.muestraResultados = function(div, json) {
			
			div.append('<br>').show();
			
			var json_result = json.data;
			
			if (json_result.length && json_result.length > 0) {
				
				var detalle = [];
				
				var tr = '';
				
				if (json && json.sql) {
					tr = '<table  cellpadding="0" cellspacing="0" style="border: 1px solid black; width:100%;"><tr>' +
						 '<td style="background-color: #cccccc; width: 40px;border: 1px solid black;">SQL</td>' +
						 '<td style="border: 1px solid black;">' + json.sql + '</td>' +
						 '<td style="width: 50px;border: 1px solid black; padding:2px;">' +
						 '<a href="javascript:;" style="padding:2px;" class="export_csv" query="' + json.sql + '" maxrows="' + json.maxrows + '" title="Descargar a excel">' +
						 '<img src="./images/docExcel.png" border="0">' +
						 '</a>' +
						 '<a href="javascript:;" style="padding:5px;" class="save_query_report" query="' + json.sql + '" maxrows="' + json.maxrows + '" title="Guardar query">' +
						 '<img src="images/save.png" border="0">' +
						 '</a>' +
						 '</td>' +
						 '</tr></table>';
				}
				
				tr+='<table  cellpadding="0" cellspacing="0" style="border: 1px solid black; width: 100%;"><thead><tr style="background-color: #cccccc;">';
				
				for(obj in json_result[0]) {
					tr+='<td style="border: 1px solid black;  padding-left:2px;"><b>' + obj + '</b></td>';
					detalle.push(obj);
				}
				
				tr+='<tr></thead><tbody>';
				
				$.each(json_result, function(i, e){
					
					tr+='<tr>';
					for (var i = 0; i < detalle.length; i++) {
						tr+='<td style="border: 1px solid black; padding-left:2px;">' + e[detalle[i]] + '</td>';
					}
					tr+='</tr>';
				});
				
				tr+='</tbody></table>';
				
				div.append($('<div style="overflow: auto;height:auto; max-height:400px;">' + tr + '</div>').resizable());
				
			}else {
			
				var detalle = [];
				
				var tr = '';
				
				if (json && json.sql) {
					tr = '<table  cellpadding="0" cellspacing="0" style="border: 1px solid black; width:100%;"><tr><td style="background-color: #cccccc; width: 40px;border: 1px solid black;">SQL</td><td style="border: 1px solid black;">' + json.sql + '</td></tr></table>';
				}
				
				tr+='<table  cellpadding="0" cellspacing="0" style="border: 1px solid black;"><thead><tr style="background-color: #cccccc;">';
				tr+='<td style="border: 1px solid black;"><b>Sin resultados</b></td><tr></thead></table>';
			
				div.append($('<div style="overflow: auto;height:auto; max-height:400px;">' + tr + '</div>').resizable());
			
			}
		}
	});
	
})(jQuery);
