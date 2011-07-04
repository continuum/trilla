require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Administrador de contactos" do
  let!(:pepito) {usuario}
  let!(:cliente) {Fabricate(:cliente, :descripcion => "ACHS")}
  
  background do
    login(pepito)
    click_link "Admin"
  end
  
  scenario "Listar contactos" do
    contacto1 = Fabricate(:contacto, :nombre => 'Rosa de las Mercedes', :cliente => cliente, :email => "rosa@delasmercedes.cl")  
    contacto2 = Fabricate(:contacto, :nombre => 'Armando Casas', :cliente => cliente, :email => "armando@casas.cl")
    click_link "Contactos"
    page.should have_selector('.tr_contacto', :count => 2)
  end
  
  scenario "Eliminar contacto" do
    contacto1 = Fabricate(:contacto, :nombre => 'Rosa de las Mercedes', :cliente => cliente,:email => "rosa@delasmercedes.cl")  
    contacto2 = Fabricate(:contacto, :nombre => 'Armando Casas', :cliente => cliente, :email => "armando@casas.cl")
    click_link "Contactos"
    within_contacto_row contacto1 do
      page.evaluate_script("window.alert = function(msg) { return true; }")
      page.evaluate_script("window.confirm = function(msg) { return true; }")
      click_link "Eliminar"
    end
    page.should_not have_contacto contacto1
  end
  
  scenario "Agregar contacto" do
    click_link "Contactos"
    click_link "Nuevo Contacto"
    fill_in "Nombre", :with => "Krishnamurti"
    fill_in "Email", :with => "krisha@murti.cl"
    fill_in "Telefono", :with => "2416263"
    select "ACHS", :from => "contacto_cliente_id"
    click_button "Crear"
    page.should have_content "Krishnamurti"
  end
end

feature "Asociar contacto a proyecto" do
  let!(:pepito){usuario}
  let!(:desarrollo){Fabricate(:tarea)}
  let!(:contacto){Fabricate(:contacto)}
  let!(:cliente) {Fabricate(:cliente, :descripcion => "ACHS")}
  let!(:proyecto) {Fabricate(:proyecto,
      :descripcion => "Shuper Proyecto",
      :archivado => false,
      :contactos => [contacto])
  }
  
  background do
    login(pepito)
    click_link "Admin"
  end
  
  scenario "Asociar contacto a nuevo proyecto" do
    click_link "Proyectos"
    click_link "Crear proyecto"
    fill_in "Nombre", :with => "Proyecto Nuevo"
    fill_in "Código", :with => "NEW001"
    fill_in "Estimación", :with => 123
    select "ACHS", :from => "Cliente"
    select "Perico de los Palotes", :from => "proyecto_usuarios_select"
    click_link "Agregar Persona"
    select "Desarrollo", :from => "proyecto_tareas_select"
    click_link "Agregar Tarea"
    select "Armando Casas", :from => "proyecto_contactos_select"
    click_link "Agregar Contacto"
    click_button "Crear"
    page.should have_content "Proyecto Nuevo"
  end
  
  scenario "Asociar contacto a proyecto existente" do
    within_proyecto_row proyecto do
      click_link "Shuper Proyecto"
    end
    page.should have_content "Armando Casas"
  end
end