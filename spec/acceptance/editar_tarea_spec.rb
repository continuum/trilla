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
    page.should_not have_content "Nueva Tarea"
    page.should have_content "Tarea cambiada"
    page.should have_content "No Facturable"
    page.should_not have_content "Desarrollo"
  end

end