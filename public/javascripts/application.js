
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
}

function remove_fields(link) {
  var hidden_field = $(link).prev("input[type=hidden]");
  if (hidden_field) {
    hidden_field.attr("value", '1');
  }
  $(link).parents(".fields").hide();
}


