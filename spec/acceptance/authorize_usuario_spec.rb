require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Autorizar usuario" do
  let!(:usuario) do
    Fabricate(:usuario,
      :nombres => "yo",
      :email => "me@continuum.cl",
      :perfil => "USUARIO"
    )
  end
  
  background do
    login usuario
  end
  
  scenario "en vista principal" do
    page.should have_link "yo"
    page.should have_link "Timesheet"
    page.should_not have_link "Admin"
    page.should_not have_link 'Proyectos'
    page.should_not have_link 'Tareas'
    page.should_not have_link 'Usuarios'
    page.should_not have_link 'Clientes'
  end
  
  scenario "tratando de ir donde no se debe" do
    visit "/proyectos"
    page.should have_content "No posee perfil de administrador para acceder a esta opción"
    visit "/clientes"
    page.should have_content "No posee perfil de administrador para acceder a esta opción"
    visit "/tareas"
    page.should have_content "No posee perfil de administrador para acceder a esta opción"
    visit "/usuarios"
    page.should have_content "No posee perfil de administrador para acceder a esta opción"
  end
  
  scenario "viendo perfil" do
    click_link "yo"
    page.should have_content "me@continuum.cl"
    page.should have_content "USUARIO"
    page.should have_link 'Editar'
    page.should_not have_link 'Listado'
    page.should_not have_link 'Usuarios'
  end
  
  scenario "editando perfil" do
    click_link "yo"
    click_link 'Editar'
    fill_in "Nombres", :with => "Quiero ser admin"
    fill_in "E-mail", :with => "pseudoadmin@continuum.cl"
    page.should_not have_select "Perfil"
    click_button "Actualizar"
    page.should have_link "Quiero ser admin"
    page.should_not have_link "yo"
    page.should have_content "pseudoadmin@continuum.cl"
    page.should have_content "USUARIO"
    page.should_not have_content "me@continuum.cl"
    
  end
  
end
