require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Autorizar administador" do
  let!(:admin) do
    Fabricate(:usuario,
      :nombres => "Jefecito",
      :email => "boss@continuum.cl",
      :perfil => "ADMIN"
    )
  end
  
  background do
    login admin
  end

  scenario "en vista principal" do
    page.should have_link "Jefecito"
    page.should have_link "Timesheet"
    page.should have_link "Admin"
    click_link "Admin"
    page.should have_link 'Proyectos'
    page.should have_link 'Tareas'
    page.should have_link 'Usuarios'
    page.should have_link 'Clientes'
    
  end
  
  scenario "viendo perfil" do
    click_link "Jefecito"
    page.should have_content "boss@continuum.cl"
    page.should have_content "ADMIN"
    page.should have_link 'Editar'
    page.should have_link 'Listado'
  end

  scenario "bajando de perfil" do
    click_link "Jefecito"
    click_link 'Editar'
    fill_in "Nombres", :with => "Quiero ser proletario"
    fill_in "E-mail", :with => "peon@continuum.cl"
    select "Usuario"
    click_button "Actualizar"
    page.should have_link "Quiero ser proletario"
    page.should_not have_link "Jefecito"
    page.should have_content "peon@continuum.cl"
    page.should_not have_content "boss@continuum.cl"
    page.should have_content "USUARIO"
    page.should_not have_content "ADMIN"
    page.should_not have_link "Admin"
    page.should_not have_link 'Proyectos'
    page.should_not have_link 'Tareas'
    page.should_not have_link 'Usuarios'
    page.should_not have_link 'Clientes'
    page.should_not have_link 'Listado'

  end
  

end
