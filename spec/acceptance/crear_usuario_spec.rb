require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Crear Usuario" do
  let!(:ricardo) do
    Fabricate(:usuario,
      :nombres => "Ricardo Meruane",
      :email => "gracias@nosemolesten.cl",
      :perfil => "ADMIN"
    )
  end
  
  background do
    login
    click_link "Admin"
    click_link "Usuarios"
  end

  scenario "sin datos" do
    click_link "Crear usuario"
    click_button "Crear"
    page.should have_content "Debe ingresar el nombre del usuario"
    page.should have_content "Debe ingresar el e-mail del usuario"
    #page.should have_content "Debe ingresar un perfil"
    page.should_not have_content "Formato de e-mail inválido"
    page.should_not have_content "Perfil inválido"
  end
  
  scenario "con e-mail inválido" do
    click_link "Crear usuario"
    fill_in "E-mail", :with => "aeiou"
    click_button "Crear"
    page.should have_content "Formato de e-mail inválido"
  end
  
  scenario "con e-mail ya existente" do
    click_link "Crear usuario"
    fill_in "E-mail", :with => "gracias@nosemolesten.cl"
    click_button "Crear"
    page.should have_content "Ya existe un usuario con esta dirección de e-mail"
  end
=begin
  #Ahora se ingresa el perfil con select, ya no es necesaria esta prueba  
  scenario "con perfil inválido" do
    click_link "Crear usuario"
    fill_in "Perfil", :with => "torturador"
    click_button "Crear"
    page.should have_content "Perfil inválido"
  end
=end  
  scenario "con perfiles válidos" do
    click_link "Crear usuario"
    fill_in "Nombres", :with => "Osama"
    fill_in "E-mail", :with => "osama@ala.com"
    select "Administrador"
    click_button "Crear"
    page.should_not have_content "Perfil inválido"
    page.should_not have_content "Nuevo Usuario"
    page.should have_content "ADMIN"
    click_link "Crear usuario"
    fill_in "Nombres", :with => "Obama"
    fill_in "E-mail", :with => "obama@usa.com"
    select "Usuario"
    click_button "Crear"
    page.should_not have_content "Perfil inválido"
    page.should_not have_content "Nuevo Usuario"
    page.should have_content "USUARIO"
  end
  
  scenario "Editar usuario" do
    click_link "Ricardo Meruane"
    fill_in "Nombres", :with => "Profesor salomon"
    fill_in "E-mail", :with => "salomon@mega.cl"
    select "Usuario"
    click_button "Actualizar"
    page.should have_content "Profesor salomon" 
    page.should have_content "salomon@mega.cl" 
    page.should_not have_content "Ricardo Meruane"
    page.should_not have_content "gracias@nosemolesten.cl"
  end
  
  scenario "Borrar usuario" do
    page.evaluate_script("window.alert = function(msg) { return true; }")
    page.evaluate_script("window.confirm = function(msg) { return true; }")
    within_usuario_row(ricardo) do
      click_link "Eliminar"
    end
    page.has_usuario?(ricardo)
    #linea conmentada, ya que usuario de login no debería ser capaz de borrarse a si mismo 
    #page.should have_content "No existen usuarios creados"
  end

end