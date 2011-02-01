var idInterval = -1;
		
/*
 *	@autor victor utreras
 */
(function ($) {

	$(document).ready(function () {

	        //$('#temporizador_tiempo_base').timeEntry({show24Hours: true});	
                $('#div-nuevo-timesheet').jqm({modal: true});

		function setTemporizador(temporizador) {
			$('#temporizador_id').val(temporizador.id);
			$('#temporizador_descripcion').val(temporizador.descripcion);
			$('#temporizador_proyecto_id').selectedValue(temporizador.proyecto_id);
			$('#temporizador_tarea_id').selectedValue(temporizador.tarea_id);
			
			var span = $('#lnk_reloj-' + temporizador.id).find('span');
			$('#temporizador_tiempo_base').val($(span[1]).text().trim());
		}
		
		$('#temporizador_descripcion').addValidateMaxLength();
		
		$('#temporizador_tiempo_base').keypress(function (event){

			var otrosKeys = [0,8];
			
			if ($(this).val().length == 2){
				otrosKeys.push(58);
			}

			if($.inArray(event.which, otrosKeys) == -1 && (event.which < 48 || event.which > 57) || event.which == 13) {
				event.preventDefault();
			    return false;
			}
			
		}).keyup(function(e){
			if ($(this).val() === '') {
				$('#lnk-span-guardar-timesheet').text('Iniciar');
			} else {
				$('#lnk-span-guardar-timesheet').text('Guardar');
			}			
		});
		
		/**
		 * 
		 * @param {Object} event
		 */
		$('.lnk-nuevo-timesheet').click(function(event){
                       	$('#lnk-span-guardar-timesheet').text('Guardar');
			var temporizador = {id: -1, descripcion: '', proyecto_id: 1, tarea_id: 1};
			setTemporizador(temporizador);
                        $('#div-nuevo-timesheet').jqmShow();
			event.preventDefault();
		});
		
		
		/**
		 * 
		 * @param {Object} params
		 * @param {Object} callback
		 */
		function update(params, callback) {
			$.get('update',params,function(data){
				 $('#tr_timesheet-' + params.id).empty().append(data);
				 if (callback) {
				 	 callback();
				 }
			});
		}
		
		/**
		 * 
		 * @param {Object} form_params
		 * @param {Object} iniciado
		 * @param {Object} callback
		 */
		function create(form_params, iniciado, callback) {
			
			form_params+='&iniciado=' + iniciado;
			$.get('create?' + form_params, function(div){
				$('#container-temporizadores').empty().append(div);
				if (callback) {
					callback();	
				}
			});
		}
		
		/**
		 * 
		 * @param {Object} form_params
		 * @param {Object} iniciado
		 * @param {Object} callback
		 */
		function edit(form_params, callback) {
		
			$.get('edit?' + form_params, function(div){
				$('#container-temporizadores').empty().append(div);
				if (callback) {
					callback();	
				}
			});
		}
		
		/**
		 * 
		 * @param {Object} event
		 */
		$('#lnk-guardar-timesheet').click(function(event){
			create_update();
			event.preventDefault();
		});
			
		/**
		 * 
		 * @param {Object} id
		 */	
		function create_update() {
			
			var id = $('#temporizador_id').val();
			
			var tiempo_base = $('#temporizador_tiempo_base').val();
			
			var form_params = $('#form-nuevo').serialize();
			
			if (Number(id) != -1) {
			
				edit(form_params, function(){
					bind_click_lnk_reloj();
					$('#div-nuevo-timesheet').jqmHide();
				});
			
			} else {
			
				var reloj_running = $('#reloj-running');
			
				//si existe un reloj corriendo
				if (reloj_running.attr('id') != undefined) {
				
					if (StringUtils.isBlank(tiempo_base)) {
					
						console.info('detener, crear, iniciar');
						
						var params = {
							accion: 'stop',
							id: reloj_running.getTitle(),
							time: reloj_running.text(),
							format: 'html'
						}
						update(params);
						
						create(form_params, 1, function(){
							bind_click_lnk_reloj();
							reset_times();
							$('#div-nuevo-timesheet').jqmHide();
						});
						
					} else {
					
						console.info('crear');
						create(form_params, 0, function(){
							bind_click_lnk_reloj();
						});
					}
					
				} else {
					console.info('crear, iniciar');
					create(form_params, 1, function(){
						bind_click_lnk_reloj();
						reset_times();
						$('#div-nuevo-timesheet').jqmHide();
					});
				}
			}
		}	
			
		/**
		 * 
		 */	
		function bind_click_lnk_reloj() {
			
			/**
			 * 
			 * @param {Object} event
			 */
			$('.lnk_editar_timesheet').unbind('click').click(function(event){
		                $('#lnk-span-guardar-timesheet').text('Actualizar');
                                
				var id = $(this).getIdSplit('-')[1];
                                if ($('#lnk_reloj-' + id).attr("title") == "Detener")
                                  $('#lnk_reloj-' + id).click();

				var temporizador = jsonToObject($('#json_editar_timesheet-' + id).text()).temporizador;
				
				setTemporizador(temporizador);
				$('#div-nuevo-timesheet').jqmShow();
				
				event.preventDefault();
			});
			
			/**
			 * 
			 * @param {Object} event
			 */
			$('.lnk_borrar_timesheet').unbind('click').click(function(event){
			
				var id = $(this).getIdSplit('-')[1];
				
				if (confirm('Estas seguro?')) {
				
					$.getJSON('delete',{id: id}, function(json){
						if(json.success){
							$('#tr_timesheet-' + id).fadeOut();
						}
					});
				}
				
				event.preventDefault();
			});
			
			/**
			 * 
			 * @param {Object} event
			 */
			$('.lnk_reloj').unbind('click').click(function(event){
				
				var el = $(this);
				var id = el.getIdSplit('-')[1];
				
				if (el.getTitle() === 'Iniciar') {
					
					var reloj_running = $('#reloj-running');
				
					//si existe un reloj corriendo, lo detiene
					if (reloj_running.attr('id') != undefined) {
						
						var params = {
							accion: 'stop',
							id: reloj_running.getTitle(),
							time: reloj_running.text(),
							format: 'html'
						}
						update(params);
					}
					
					//inicia el reloj seleccionado
					var params = {
						accion: 'start',
						id: id,
						time: $('#reloj-' + id).text(),
						format: 'html'
					}
					
					update(params, function(){
						bind_click_lnk_reloj();
						reset_times();
					});
					
				} else {
					
					//detiene el reloj seleccionado
					var reloj_running = $('#reloj-running');
					var params = {
						accion: 'stop',
						id: reloj_running.getTitle(),
						time: reloj_running.text(),
						format: 'html'
					}
					
					update(params, function(){
						bind_click_lnk_reloj();
					});
				}
				
				event.preventDefault();
			});
		}
		
		var msgImportante = 'Ser&aacute; que estas trabajando mucho?';
		
		function reset_times() {
			
			clearInterval(idInterval);
			
			var reloj_running = $('#reloj-running');
			
			if (reloj_running.attr('id') == undefined) return;
			
			var tiempos = reloj_running.text().split(':');
			var dia = Number(tiempos[3]);
			var segundo = Number(tiempos[2]);
			var minuto = Number(tiempos[1]);
			var hora = Number(tiempos[0]);
				
			if(hora >= 9) {
				$('#div-msg-salud').empty().append(msgImportante);
			} 
		
			idInterval = setInterval(function(){
				
				var relojRunning = $('#reloj-running');
				
				if (relojRunning.attr('id') != undefined) {
				
					segundo++;
					
					if (segundo > 59) {
						minuto++;
						segundo = 0;
					}
					
					if (minuto > 59) {
						hora++;
						segundo = 0;
						minuto = 0;
						if (hora >= 9) {
							$('#div-msg-salud').empty().append(msgImportante);
						}
					}
					
					if (hora > 24) {
						dia++;
						hora = 0;
						segundo = 0;
						minuto = 0;
					}
				
					relojRunning.text(hora + ':' + minuto + ':' + segundo + ':' + dia);
					//console.info(relojRunning.text());
					
					var s = (hora.toString().length == 1 ? '0' + hora : hora) + ':' +
							(minuto.toString().length == 1 ? '0' + minuto : minuto);
					
					$('#reloj-running-display').text(s);
				}
				
			}, 1000);
		}
		
		bind_click_lnk_reloj();
		reset_times();
		
		$( "#datepicker" ).datepicker({
			dateFormat: 'yy-mm-dd',
			maxDate: "+0D",
			minDate: "-1y",
			showOn: "button",
			buttonImage: "/harv/images/icons/calendar.gif",
			buttonImageOnly: true,
			gotoCurrent: true,
			changeMonth: true,
			changeYear: true,
			onSelect: function(dateText, inst) { 
				var form = $('#form-submit-timesheet form');
				form.find('input[name=fecha]').val(dateText);
				form.attr('action','day');
				form.submit();
			}
		});
		
		/**
		 * este codigo lo invente yo, no aseguro que funcione con otra version de jquery
		 * @param {Object} accion
		 */
		function changeDate(accion){
			
			var fecha = $( "#datepicker" ).val().split('-');
			var dia = Number(fecha[2]);
			var mes = Number(fecha[1]);
			var anio = Number(fecha[0]);
			
			if (accion === 'next') {
				dia++;
			} else {
				dia--;	
			}

			var fechaActual = new Date().toIntDate();
			
			var d = dia.toString();
			var m = mes.toString();
			
			if (d.length == 1) {
				d = '0' + d;
			}
			
			if (m.length == 1) {
				m = '0' + m;
			}
			
			var fechaElegida = Number(anio + m + d);
			
			var td = undefined;
			
			if (fechaElegida <= fechaActual)
				td = '<td class="ui-datepicker-current-day"><a href="#" class="ui-state-default ui-state-active">' + dia + '</a></td>';
			else {
				td = '<td class=" ui-datepicker-week-end ui-datepicker-unselectable ui-state-disabled "><span class="ui-state-default">' + dia + '</span></td>';
			}
			
			$.datepicker._selectDay('#datepicker', mes-1, anio, $(td));
		}
		
		
		/**
		 * 
		 * @param {Object} event
		 */
		$('#prev-day').click(function(event){
			console.info('before-day',$( "#datepicker" ).val());	
			changeDate('prev');
			event.preventDefault();
		});
		
		/**
		 * 
		 * @param {Object} event
		 */
		$('#next-day').click(function(event){
			console.info('after-day',$( "#datepicker" ).val());	
			changeDate('next');
			event.preventDefault();
		});
		
		/**
		 * 
		 * @param {Object} event
		 */
		$('.lnk-perfil-usuario').click(function(event){
			location.href = $('#path-perfil-usuario').text();
			event.preventDefault();
		});
		
	});	
	
})(jQuery);		
