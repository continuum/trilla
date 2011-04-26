require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Borrar Tarea" do
  let!(:shuper) { Fabricate(:tarea) }
  
  background do
    login
    click_link "Admin"
    click_link "Tareas"
  end
  
  scenario "sin proyectos" do
    page.evaluate_script("window.alert = function(msg) { return true; }")
    page.evaluate_script("window.confirm = function(msg) { return true; }")
    within_tarea_row(shuper) do
      click_link "Eliminar"
    end
    page.should_not have_tarea shuper
    page.should have_content "No existen tareas creadas"
  end

  scenario "con proyectos asociados" do
    proyecto_tarea = Fabricate(:proyecto_tarea,
      :tarea => shuper,
      :proyecto => Fabricate(:proyecto)
    )
    page.evaluate_script("window.alert = function(msg) { return true; }")
    page.evaluate_script("window.confirm = function(msg) { return true; }")
    within_tarea_row(shuper) do
      click_link "Eliminar"
    end
    page.should have_tarea shuper
    page.should_not have_content "No existen tareas creadas"
    page.should have_content "La tarea ha sido referenciada desde un proyecto"
  end

end