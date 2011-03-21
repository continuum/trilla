require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Crear Proyecto" do
  p1 = nil
  p2 = nil
  
  background do
    Fabricate(:cliente, :descripcion => "Perico")
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

  scenario "sin datos" do
    click_link "Nuevo proyecto"
    click_button "Crear"
    page.should have_content("Debe ingresar un nombre para el proyecto")
    page.should have_content("Debe seleccionar un cliente")
  end
  
  scenario "con los datos basicos" do
    click_link "Nuevo proyecto"
    fill_in "Nombre", :with => "Proyecto Trilla"
    fill_in "Código", :with => "T3"
    fill_in "Estimación", :with => "100"
    select "Perico", :from => "Cliente"
    click_button "Crear"
    page.should have_content("Mis Proyectos")
    page.should have_content("Proyecto Trilla")
    page.has_select?("proyecto_cliente_id", :selected =>"Perico")
    click_link "Proyecto Trilla"
    field_labeled("Código").value.should == "T3"
    field_labeled("Estimación").value.should == "100"
  end

  scenario "proyecto existente" do
    click_link "Nuevo proyecto"
    fill_in "Nombre", :with => p1.descripcion
    select "Juanito", :from => "Cliente"
    click_button "Crear"
    page.should have_content("Ya existe un proyecto con el mismo nombre")
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
