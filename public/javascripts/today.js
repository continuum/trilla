var idInterval = -1;
var REFRESH_EVENT = 'refreshTotalHours';

(function ($) {

  $(document).ready(function () {

    $('#div-nuevo-timesheet').jqm({modal: true});

  function calculateTimeExpression(event){
    var temporizadorTiempoBase = $(event.currentTarget),
        temporizadorTiempoBaseValue = temporizadorTiempoBase.val(),
        itIsExpression = function(value){return /^\d{0,2}:\d{2}([+-]\d{0,2}:\d{2})+$/.test(value)};
    if (itIsExpression(temporizadorTiempoBaseValue)){
      var operators = temporizadorTiempoBaseValue.split(/\d{0,2}:\d{2}/),
          times     = temporizadorTiempoBaseValue.split(/[+-]/);
      var calculatedTime, i;
      for (i = 0; i < times.length; i++) {
        if (i == 0){
          calculatedTime = times[i];
          continue;
        }
        if (operators[i] == '+'){
          calculatedTime = sumTwoHours(calculatedTime, times[i]);
        }else
        if (operators[i] == '-'){
          calculatedTime = subtractTwoHours(calculatedTime, times[i]);
        }
      }
      temporizadorTiempoBase.val(calculatedTime);
    }else{
      var match = /^(\d{0,2}:\d{2}).*$/.exec(temporizadorTiempoBaseValue);
      if (match)
        temporizadorTiempoBase.val(match[1]);
    }
  };

	function setTemporizador(temporizador) {
		$('#temporizador_id').val(temporizador.id);
		$('#temporizador_descripcion').val(temporizador.descripcion);
		$('#temporizador_proyecto_id').selectedValue(temporizador.proyecto_id);
		$('#temporizador_tarea_id').selectedValue(temporizador.tarea_id);
		var span = $('#lnk_reloj-' + temporizador.id).find('span');
		$('#temporizador_tiempo_base').val($(span[1]).text().trim());
    $('#temporizador_tiempo_base').unbind('change').change(calculateTimeExpression);
    $('#lnk-guardar-timesheet').attr('disabled', '');
	}

	$('#temporizador_descripcion').addValidateMaxLength();

  $('#temporizador_tiempo_base').keypress(function (event) {
		var otrosKeys = [0,8, 58, 43, 45]; // 43 == + y 45 == -
		if ($.inArray(event.which, otrosKeys) == -1 && (event.which < 48 || event.which > 57) || event.which == 13) {
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

	$('.lnk-nuevo-timesheet').click(function(event){
      	$('#lnk-span-guardar-timesheet').text('Iniciar');
		var temporizador = {id: -1, descripcion: '', proyecto_id: 1, tarea_id: 1};
		setTemporizador(temporizador);
      	$('#div-nuevo-timesheet').jqmShow();
		event.preventDefault();
	});

	function update(params, callback) {
		$.get('/timesheet/update',params,function(data){
			 $('#tr_temporizador_' + params.id).empty().append(data);
			 if (callback) {
			 	 callback();
			 }
		});
	}

  function create(form_params, iniciado, callback) {
		form_params+='&iniciado=' + iniciado;
		$.get('/timesheet/create?' + form_params, function(div){
			$('#container-temporizadores').empty().append(div);
			if (callback) {
				callback();
			}
		});
	}

  function edit(form_params, callback) {
		$.get('/timesheet/edit?' + form_params, function(div){
			$('#container-temporizadores').empty().append(div);
			if (callback) {
				callback();
			}
		});
	}

	$('#lnk-guardar-timesheet').click(function(event){
		create_update();
		event.preventDefault();
	});

  function isValidTimeField(timeField){
    var timeFieldValue = timeField.replace(/\s/g, '');
    return /^\d{0,2}(:\d{2})?([+-]\d{0,2}:\d{2})*$/.test(timeFieldValue) || timeFieldValue.blank();
  }

  function create_update(){
      var id = $('#temporizador_id').val();
      var tiempo_base = $('#temporizador_tiempo_base').val();
      var link_guardar_timesheet = $('#lnk-guardar-timesheet');
      var descripcion_temporizador = $('#temporizador_descripcion');
      link_guardar_timesheet.attr('disabled', 'disabled');

      if (descripcion_temporizador.val().length > 255){
        if (confirm('Ha ingresado una descripción demasiado extensa. ¿Desea que truncarla hasta el máximo permitido?')){
          descripcion_temporizador.val(descripcion_temporizador.val().substring(0,255));
        }else{
          link_guardar_timesheet.attr('disabled', '');
          return;
        }
      }

      var form_params = $('#form-nuevo').serialize() + "&" + $('#fecha').serialize();

      var _create_edit_fn = function(_function, mustReset, secondParam){
        var commonCallBack = function(){
          bind_click_lnk_reloj();
          if (mustReset)
            reset_times();
          $('#div-nuevo-timesheet').jqmHide();
          link_guardar_timesheet.trigger(REFRESH_EVENT);
        };
        if (secondParam != undefined){
          _function(form_params, secondParam, commonCallBack);
        } else {
          _function(form_params, commonCallBack);
        }
      };

      if (!isValidTimeField(tiempo_base)){
        alert('El formato de la hora ingresada no es válido. Debe ser HH:MM([+-]HH:MM)*');
        link_guardar_timesheet.attr('disabled', '');
        return;
      }

      if (Number(id) != -1) {
        _create_edit_fn(edit);
      } else {
          var reloj_running = $('#reloj-running');
          //si existe un reloj corriendo
          if (reloj_running.attr('id') != undefined) {
              if (StringUtils.isBlank(tiempo_base)) {
                  var params = {
                      accion: 'stop',
                      id: reloj_running.getTitle(),
                      time: reloj_running.text(),
                      format: 'html'
                  }
                  update(params);
                  _create_edit_fn(create, true, 1);
              } else {
                _create_edit_fn(create, false, 0);
              }
          } else {
              _create_edit_fn(create, true, 1);
          }
      }
  }

  function bind_click_lnk_reloj() {
		$('.lnk_editar_timesheet').unbind('click').click(function(event){
			$('#lnk-span-guardar-timesheet').text('Actualizar');
			var id = $(this).getIdSplit('-')[1];
	        if ($('#lnk_reloj-' + id).attr("title") == "Detener") {
	          $('#lnk_reloj-' + id).click();
	        }
	        var temporizador = jsonToObject($('#json_editar_timesheet-' + id).text()).temporizador;
			setTemporizador(temporizador);
	        $('#div-nuevo-timesheet').jqmShow();
			event.preventDefault();
		});

		$('.lnk_borrar_timesheet').unbind('click').click(function(event){
			var id = $(this).getIdSplit('-')[1];
			if (confirm('Estas seguro?')) {
				$.getJSON('/timesheet/delete',{id: id}, function(json){
					if(json.success){
						$('#tr_temporizador_' + id).fadeOut(function(){
              var currentTarget = $(event.currentTarget);
              currentTarget.trigger(REFRESH_EVENT);
              currentTarget.parents('.tr_temporizador').remove();
            });
					}
				});
			}
			event.preventDefault();
		});

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
          update(params, function(){$(event.currentTarget).trigger(REFRESH_EVENT);});
				}
	
				//inicia el reloj seleccionado
				var params = {
					accion: 'start',
					id: id,
					time: $('#reloj-' + id).text().trim(),
					format: 'html'
	          	}
				update(params, function(){
					bind_click_lnk_reloj();
					reset_times();
          $(event.currentTarget).trigger(REFRESH_EVENT);
				});
	
			} else {
	
				//detiene el reloj seleccionado
				var reloj_running = $('#reloj-running');
				var params = {
					accion: 'stop',
					id: reloj_running.getTitle(),
					time: reloj_running.text().trim(),
					format: 'html'
	          	}
				update(params, function(){
					bind_click_lnk_reloj();
          $(event.currentTarget).trigger(REFRESH_EVENT);
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
//		console.info(tiempos);
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
				//console.info(hora + ':' + minuto + ':' + segundo + ':' + dia);
				var s = (hora.toString().length == 1 ? '0' + hora : hora) + ':' +
	            		(minuto.toString().length == 1 ? '0' + minuto : minuto);
						
				$('#reloj-running-display').text(s);
	        }
		}, 1000);
	}

	bind_click_lnk_reloj();
	reset_times();

	$( "#datepicker" ).datepicker({
		dateFormat: 'dd/mm/yy',/*
		maxDate: "+0D",
		minDate: "-1y",*/
		firstDay: '1',
		showOn: "button",
		buttonImage: "/harv/images/icons/calendar.gif",
		buttonImageOnly: true,
		gotoCurrent: true,
		changeMonth: true,
		changeYear: true,
		onSelect: function(dateText, inst) {
			fecha = Date.parse(dateText);
			var form = $('#form-submit-timesheet form');
			var action = "/timesheet/day/" + (fecha.getDayOfYear() + 1) + "/" + fecha.getFullYear();
			form.attr('action',action);
			form.submit();
		}
	});

	/**
	 * este codigo lo invente yo, no aseguro que funcione con otra version de jquery
	 * @param {Object} accion
	 */
    function changeDate(accion){
		var fecha = $( "#datepicker" ).val().split('/');
		var dia = Number(fecha[0]);
		var mes = Number(fecha[1]);
  		var anio = Number(fecha[2]);
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
		if (fechaElegida <= fechaActual+4) {
			td = '<td class="ui-datepicker-current-day"><a href="#" class="ui-state-default ui-state-active">' + dia + '</a></td>';
		} else {
			td = '<td class=" ui-datepicker-week-end ui-datepicker-unselectable ui-state-disabled "><span class="ui-state-default">' + dia + '</span></td>';
		}
		$.datepicker._selectDay('#datepicker', mes-1, anio, $(td));
    }

	$('.lnk-perfil-usuario').click(function(event){
		location.href = $('#path-perfil-usuario').text();
		event.preventDefault();
	});
	
  $.refreshTotalHours = function(event){
    var hours_of_day = $('#total_hours_of_day #hours_of_day');
    var temporizadores = $('#container-temporizadores .component-timesheet:visible');
    if (temporizadores.length == 0)
      hours_of_day.html('00:00');
    else{
      var horas_temporizadores = [];
      temporizadores.each(function(i, temporizador){
        var hora_temporizador = $(temporizador).find('.clock').html().trim();
        horas_temporizadores.push(hora_temporizador);
      });
      var hours_sum = sumArrayHours(horas_temporizadores);
      hours_of_day.html(hours_sum);
    }
    if (event && (typeof event.isPropagationStopped) == 'function' && !event.isPropagationStopped())
      event.stopPropagation();
  };
  
  $('.lnk_borrar_timesheet').bind(REFRESH_EVENT, $.refreshTotalHours);
  $('#lnk-guardar-timesheet').bind(REFRESH_EVENT, $.refreshTotalHours);
  $('.lnk_reloj').die(REFRESH_EVENT).live(REFRESH_EVENT, $.refreshTotalHours);
  
  $.refreshTotalHours();
  
  // Actualiza el total de horas del día cada un minuto.
  if ($.intervalRefreshTotalHoursId == undefined){
    $.intervalRefreshTotalHoursId = window.setInterval($.refreshTotalHours, 60000);
  }

  });
})(jQuery);
