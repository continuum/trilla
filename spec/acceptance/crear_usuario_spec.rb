require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Crear Usuario" do
  usuario = nil
  
  background do
    usuario = Fabricate(:usuario,
      :nombres => "Ricardo Meruane",
      :email => "gracias@nosemolesten.cl",
      :perfil => "ADMIN"
    )
    login
    click_link "Admin"
    click_link "Usuarios"
  end

  scenario "Sin datos" do
    click_link "Crear usuario"
    click_button "Crear"
    page.should have_content "Debe ingresar el nombre del usuario"
    page.should have_content "Debe ingresar el e-mail del usuario"
    page.should have_content "Debe ingresar un perfil"
    page.should_not have_content "Formato de e-mail inválido"
    page.should_not have_content "Perfil inválido"
  end
  
  scenario "E-mail inválido" do
    click_link "Crear usuario"
    fill_in "E-mail", :with => "aeiou"
    click_button "Crear"
    page.should have_content "Formato de e-mail inválido"
  end
  
  scenario "E-mail ya existente" do
    click_link "Crear usuario"
    fill_in "E-mail", :with => usuario.email
    click_button "Crear"
    page.should have_content "Ya existe un usuario con esta dirección de e-mail"
  end
  
  scenario "Perfil inválido" do
    click_link "Crear usuario"
    fill_in "Perfil", :with => "torturador"
    click_button "Crear"
    page.should have_content "Perfil inválido"
  end
  
  scenario "Perfiles válidos" do
    click_link "Crear usuario"
    fill_in "Nombres", :with => "Osama"
    fill_in "E-mail", :with => "osama@ala.com"
    fill_in "Perfil", :with => "ADMIN"
    click_button "Crear"
    page.should_not have_content "Perfil inválido"
    page.should_not have_content "Nuevo Usuario"
    page.should have_content "ADMIN"
    click_link "Crear usuario"
    fill_in "Nombres", :with => "Obama"
    fill_in "E-mail", :with => "obama@usa.com"
    fill_in "Perfil", :with => "USUARIO"
    click_button "Crear"
    page.should_not have_content "Perfil inválido"
    page.should_not have_content "Nuevo Usuario"
    page.should have_content "USUARIO"
  end
  
  scenario "Editar usuario" do
    click_link usuario.nombres
    fill_in "Nombres", :with => "Profesor salomon"
    fill_in "E-mail", :with => "salomon@mega.cl"
    fill_in "Perfil", :with => "USUARIO"
    click_button "Actualizar"
    page.should have_content "Profesor salomon" 
    page.should have_content "salomon@mega.cl" 
    page.should have_content "USUARIO"
    page.should_not have_content "Ricardo Meruane"
    page.should_not have_content "gracias@nosemolesten.cl"
    page.should_not have_content "ADMIN"
  end
  
  scenario "Borrar usuario" do
    page.evaluate_script("window.alert = function(msg) { return true; }")
    page.evaluate_script("window.confirm = function(msg) { return true; }")
    within_usuario_row(usuario) do
      click_link "Eliminar"
    end
    page.has_usuario?(usuario)
    page.should have_content "No existen usuarios creados"
  end

end