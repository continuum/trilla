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
    select "No Facturable"
    click_button "Actualizar"
    #save_and_open_page
    page.should_not have_content "Nueva Tarea"
    page.should have_content "Tarea cambiada" 
    page.should have_content "No Facturable"
    page.should_not have_content "Desarrollo"
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