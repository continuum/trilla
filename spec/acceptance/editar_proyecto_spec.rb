require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Editar Proyecto" do
  let!(:shuper) do
    Fabricate(:proyecto,
      :descripcion => "Shuper Proyecto",
      :archivado => false
    )    
  end
  
  let!(:archivado) do
    Fabricate(:proyecto,
      :descripcion => "Proyecto archivado",
      :archivado => true
    )
  end
  
  background do
    Fabricate(:cliente, :descripcion => "Perico")
    login
    click_link "Admin"
    click_link "Proyectos"
  end

  #TODO: Falta editar tareas y usuarios ingresados
  scenario "cambiando datos basicos" do
    click_link "Shuper Proyecto"
    fill_in "Nombre", :with => "Proyecto Trilla"
    fill_in "Código", :with => "T3"
    fill_in "Estimación", :with => "100"
    check "Archivado"
    select "Perico", :from => "Cliente"
    click_button "Actualizar"
    page.should_not have_content "Nuevo Proyecto"
    page.should have_content "Proyecto Trilla"
    page.should_not have_content "Shuper Proyecto"    
    click_link "Proyecto Trilla"
    page.should have_select("Cliente", :selected => "Perico")
    page.should have_checked_field("Archivado") 
    field_labeled("Código").value.should == "T3"
    field_labeled("Estimación").value.should == "100"
  end
  
  scenario "archivando el proyecto" do
    within_proyecto_row(shuper) do
      click_link "Archivar"   
    end
    within_proyecto_row(shuper) do
      page.should have_content("Recuperar")
    end
  end

  scenario "recuperando el proyecto" do
    within_proyecto_row(archivado) do
      click_link "Recuperar"
    end
    within_proyecto_row(archivado) do
      page.should have_content("Archivar")
    end
  end
  
  scenario "borrando proyectos" do
    page.evaluate_script("window.alert = function(msg) { return true; }")
    page.evaluate_script("window.confirm = function(msg) { return true; }")
    within_proyecto_row(shuper) do
      click_link "Eliminar"
    end
    page.has_proyecto?(shuper)
    page.evaluate_script("window.alert = function(msg) { return true; }")
    page.evaluate_script("window.confirm = function(msg) { return true; }")
    within_proyecto_row(archivado) do
      click_link "Eliminar"
    end
    page.has_proyecto?(archivado)
    page.should have_content "No existen proyectos creados"
  end
end