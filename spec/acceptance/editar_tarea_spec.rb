require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Editar Tarea" do
  let!(:shuper) { Fabricate(:tarea) }
  
  background do
    login
    click_link "Admin"
    click_link "Tareas"
  end
  
  scenario "cambiando todos sus datos" do
    click_link "Desarrollo"
    fill_in "Nombre", :with => "Tarea cambiada"
    fill_in "Tipo", :with => "Importantísima!"
    click_button "Actualizar"
    page.should_not have_content "Nueva Tarea"
    page.should have_content "Tarea cambiada" 
    page.should have_content "Importantísima!" 
    page.should_not have_content "Desarrollo"
    page.should_not have_content "Facturable"
  end
  
  scenario "borrando y verificando que no existen mas tareas" do
    page.evaluate_script("window.alert = function(msg) { return true; }")
    page.evaluate_script("window.confirm = function(msg) { return true; }")
    within_tarea_row(shuper) do
      click_link "Eliminar"
    end
    page.has_tarea?(shuper)
    page.should have_content "No existen tareas creadas"
  end

end