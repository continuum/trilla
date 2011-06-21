
//TODO: Falta agregar validaciones para borrar/agregar usuarios/tareas
function insert_fields(link, method, content) {
  var ex_id = ($("#" + method + "_select").val());
  if(ex_id > 0){
  	  var esta_agregado = false;
      $('.'+ method + '_hidden').each(function(){
	  	var campo = $(this);
	  	var v = campo.val();
		if(v == ex_id){
			//Si está oculto, ya fue borrado anteriormente, por tanto, se vuelve a mostrar
//			console.info(campo.is(':hidden'));
//			console.info(campo.parents(".fields").is(':hidden'));
			var padre = campo.parents(".fields");
			if(padre.is(':hidden')){
				var input = padre.show().find('input:last');
				input.attr("value", '');
				
			}
			esta_agregado = true;
			return;
		}
	  });
	  if(!esta_agregado){
		  var new_id = new Date().getTime();
		  var new_value = ($("#" + method + "_select option:selected").text())
		  var regexp = new RegExp("new_" + method, "g")
		  content = content.replace("type=\"hidden\"", "type='hidden' class='"+ method + "_hidden' value='" + ex_id + "'");
		  content = content.replace("<span>","<span>" + new_value.trim());
		  $(link).parent().before(content.replace(regexp, new_id));
	  }
  }
};

function remove_fields(link) {
  var hidden_field = $(link).prev("input[type=hidden]");
  if (hidden_field) {
    hidden_field.attr("value", '1');
  }
  $(link).parents(".fields").hide();
};

/**
 * @param {integer} minutes
 * @return {string} "HH:MM"
 */
function minutesToHours(minutes){
    var division = minutes / 60;
    var hours = parseInt(division);
    var minutes = Math.round((division - hours) * 60);
    return $.leftPad(hours, 2) + ":" + $.leftPad(minutes,2);
};

/**
 * @param {string} hour1 "HH:MM"
 * @param {string} hour2 "HH:MM"
 * @return {string} "HH:MM"
 */
function sumTwoHours(hour1, hour2){
  var hours_and_minutes1 = hour1.split(':'),
      hours_and_minutes2 = hour2.split(':'),
      total_minutes = parseInt(hours_and_minutes1[1], 10) + parseInt(hours_and_minutes2[1], 10) +
                      ((parseInt(hours_and_minutes1[0].blank() ? 0:hours_and_minutes1[0], 10) +
                        parseInt(hours_and_minutes2[0].blank() ? 0:hours_and_minutes2[0], 10)) * 60);
  return minutesToHours(total_minutes);
};

/**
 * @param {string} hour1 "HH:MM"
 * @param {string} hour2 "HH:MM"
 * @return {string} "HH:MM"
 */
function subtractTwoHours(hour1, hour2){
    var hours_and_minutes1 = hour1.split(':'),
      hours_and_minutes2 = hour2.split(':'),
      total_minutes = ((parseInt(hours_and_minutes1[0].blank() ? 0:hours_and_minutes1[0], 10)*60) + parseInt(hours_and_minutes1[1], 10)) - 
                      ((parseInt(hours_and_minutes2[0].blank() ? 0:hours_and_minutes2[0], 10)*60) + parseInt(hours_and_minutes2[1], 10));
    if (total_minutes < 0)
      total_minutes = 0;
    return minutesToHours(total_minutes);
};

/**
 * @param {array} arrayHours ["HH:MM","HH:MM","HH:MM"]
 * @return {string} "HH:MM"
 */
function sumArrayHours(arrayHours){
  var i;
  var acumulativeHour = "00:00";
  for (i = 0; i < arrayHours.length; i++)
    acumulativeHour = sumTwoHours(acumulativeHour, arrayHours[i]);
  return acumulativeHour;
};

$('#proyecto_estimacion').die('keypress').live('keypress', function(event){
  var otrosKeys = [0,8];
  if(jQuery.inArray(event.which, otrosKeys) == -1 && (event.which < 48 || event.which > 57) || event.which == 13) {
    event.preventDefault();
    return false;
  }
});


