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