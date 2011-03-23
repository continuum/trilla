require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Crear Proyecto" do
  p1 = nil
  p2 = nil
  
  background do
    Fabricate(:cliente, :descripcion => "Perico")
    p1 = Fabricate(:proyecto,
      :descripcion => "Shuper Proyecto",
      :archivado => false,
      :cliente => Fabricate(:cliente, :descripcion => "Juanito")
    )
    login
    click_link "Admin"
    click_link "Proyectos"
  end

  scenario "sin datos" do
    click_link "Crear proyecto"
    click_button "Crear"
    page.should have_content("Debe ingresar un nombre para el proyecto")
    page.should have_content("Debe seleccionar un cliente")
  end
  
  scenario "con los datos básicos" do
    click_link "Crear proyecto"
    fill_in "Nombre", :with => "Proyecto Trilla"
    select "Perico", :from => "Cliente"
    click_button "Crear"
    page.should have_content("Proyecto Trilla")
    page.should_not have_content "Nuevo Proyecto"
    page.has_select?("proyecto_cliente_id", :selected =>"Perico")#...esto se debería haber caido
    click_link "Proyecto Trilla"
  end

  scenario "con todos los datos" do
    click_link "Crear proyecto"
    fill_in "Nombre", :with => "Proyecto Trilla"
    fill_in "Código", :with => "T3"
    fill_in "Estimación", :with => "100"
    check "Archivado"
    select "Perico", :from => "Cliente"
    click_button "Crear"
    page.should have_content("Mis Proyectos")
    page.should have_content("Proyecto Trilla")
    click_link "Proyecto Trilla"
    page.should have_select("Cliente", :selected =>"Perico")
    page.should have_checked_field("Archivado")
    field_labeled("Código").value.should == "T3"
    field_labeled("Estimación").value.should == "100"
  end

  scenario "proyecto con nombre previamente existente" do
    click_link "Crear proyecto"
    fill_in "Nombre", :with => p1.descripcion
    select "Juanito", :from => "Cliente"
    click_button "Crear"
    page.should have_content("Ya existe un proyecto con el mismo nombre")
  end
  


end
