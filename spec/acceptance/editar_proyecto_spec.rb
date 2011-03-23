require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Crear Proyecto" do
  p1 = nil
  p2 = nil
  
  background do
    p1 = Fabricate(:proyecto,
      :id => 10,
      :descripcion => "Shuper Proyecto",
      :archivado => false,
      :cliente => Fabricate(:cliente, :descripcion => "Juanito")
    )
    p2 = Fabricate(:proyecto,
      :id => 11,
      :descripcion => "Proyecto archivado",
      :archivado => true,
      :cliente => Fabricate(:cliente, :descripcion => "Pepito")
    )
    login
    click_link "Admin"
    click_link "Proyectos"
  end

  scenario "Archivar proyecto" do
    within_proyecto_row(p1) do
      click_link "Archivar"
    end
    within_proyecto_row(p1) do
      page.should have_content("Recuperar")
    end
  end

  scenario "Recuperar proyecto" do
    within_proyecto_row(p2) do
      click_link "Recuperar"
    end
    within_proyecto_row(p2) do
      page.should have_content("Archivar")
    end
  end
  
  scenario "Borrar proyecto" do
    page.evaluate_script("window.alert = function(msg) { return true; }")
    page.evaluate_script("window.confirm = function(msg) { return true; }")
    within_proyecto_row(p1) do
      click_link "Eliminar"
    end
    page.has_proyecto?(p1)
  end

end
