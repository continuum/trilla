function insert_fields(link, method, content) {
  var ex_id = ($("#" + method + "_select").val());
  var new_id = new Date().getTime();
  var new_value = ($("#" + method + "_select option:selected").text())
  var regexp = new RegExp("new_" + method, "g")
  content = content.replace("type=\"hidden\"", "type=\"hidden\" value=\"" + ex_id + "\"");
  content = content.replace("<span>","<span>" + new_value.trim());
  $(link).parent().before(content.replace(regexp, new_id));
}

function remove_fields(link) {
  var hidden_field = $(link).prev("input[type=hidden]");
  if (hidden_field) {
    hidden_field.attr("value", '1');
  }
  $(link).parents(".fields").hide();
}
