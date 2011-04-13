require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Crear Tarea" do
  let!(:shuper) { Fabricate(:tarea) }
  
  background do
    login
    click_link "Admin"
    click_link "Tareas"
  end

  scenario "sin datos" do
    click_link "Crear tarea"
    click_button "Crear"
    page.should have_content "Debe ingresar un nombre para la tarea"
  end
  
  scenario "con los datos básicos" do
    click_link "Crear tarea"
    fill_in "Nombre", :with => "Tarea para la casa"
    click_button "Crear"
    page.should have_content "Tarea para la casa"
    page.should_not have_content "Nueva Tarea"
  end

  scenario "con todos los datos" do
    click_link "Crear tarea"
    fill_in "Nombre", :with => "Tarea para la casa"
    #fill_in "Tipo", :with => "Importantísima!"
    select "No Facturable"
    click_button "Crear"
    page.should_not have_content "Nueva Tarea"
    page.should have_content "Tarea para la casa"
    page.should have_content "No Facturable"
  end

  scenario "existente" do
    click_link "Crear tarea"
    fill_in "Nombre", :with => "Desarrollo"
    click_button "Crear"
    page.should have_content("Ya existe una tarea con el mismo nombre")
  end

end