require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Crear Tarea" do
  t1 = nil
  
  background do
    t1 = Fabricate(:tarea,
      :id => 10,
      :descripcion => "Shuper Tarea",
      :tipo => "Extraña"
    )
    login
    click_link "Admin"
    click_link "Tareas"
    page.evaluate_script("window.alert = function(msg) { return true; }")
    page.evaluate_script("window.confirm = function(msg) { return true; }")
  end

  scenario "Sin datos" do
    click_link "Crear tarea"
    click_button "Crear"
    page.should have_content "Debe ingresar un nombre para la tarea"
  end
  
  scenario "Con los datos básicos" do
    click_link "Crear tarea"
    fill_in "Nombre", :with => "Tarea para la casa"
    click_button "Crear"
    page.should have_content "Tarea para la casa"
    page.should_not have_content "Nueva Tarea"
  end

  scenario "Con todos los datos" do
    click_link "Crear tarea"
    fill_in "Nombre", :with => "Tarea para la casa"
    fill_in "Tipo", :with => "Importantísima!"
    click_button "Crear"
    page.should_not have_content "Nueva Tarea"
    page.should have_content "Tarea para la casa"
    page.should have_content "Importantísima!"
  end

  scenario "Tarea existente" do
    click_link "Crear tarea"
    fill_in "Nombre", :with => t1.descripcion
    click_button "Crear"
    page.should have_content("Ya existe una tarea con el mismo nombre")
  end
  
  scenario "Editar tarea" do
    click_link t1.descripcion
    fill_in "Nombre", :with => "Tarea cambiada"
    fill_in "Tipo", :with => "Importantísima!"
    click_button "Actualizar"
    page.should_not have_content "Nueva Tarea"
    page.should have_content "Tarea cambiada" 
    page.should have_content "Importantísima!" 
    page.should_not have_content "Shuper Tarea"
    page.should_not have_content "Extraña"
  end
  
  scenario "Borrar tarea" do
    within_tarea_row(t1) do
      click_link "Eliminar"
    end
    page.has_tarea?(t1)
  end

  scenario "Sin tareas" do
    within_tarea_row(t1) do
      click_link "Eliminar"
    end
    page.should have_content "No existen tareas creadas"
  end

end