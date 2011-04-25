require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Crear Cliente" do
  let!(:mario) do
    Fabricate(:cliente,
      :descripcion => "Don francisco",
      :contacto => "Que venga la modelo!!!",
      :fono => "24500-03"
    )
  end
  
  background do
    login
    click_link "Admin"
    click_link "Clientes"
  end

  scenario "Sin datos" do
    click_link "Crear cliente"
    click_button "Crear"
    page.should have_content "Debe ingresar un nombre para el cliente"
  end
  
  scenario "Con los datos básicos" do
    click_link "Crear cliente"
    fill_in "Nombre", :with => "Chacal de la trompeta"
    click_button "Crear"
    page.should have_content "Chacal de la trompeta"
    page.should_not have_content "Nuevo Cliente"
  end

  scenario "Con todos los datos" do
    click_link "Crear cliente"
    fill_in "Nombre", :with => "Chacal de la trompeta"
    fill_in "Contacto", :with => "Canal 13"
    fill_in "Fono", :with => "1234567"
    click_button "Crear"
    page.should_not have_content "Nuevo Cliente"
    page.should have_content "Chacal de la trompeta"
    page.should have_content "Canal 13"
    page.should have_content "1234567"
  end
  
  scenario "Editar cliente" do
    click_link "Don francisco"
    fill_in "Nombre", :with => "Patricio Flores"
    fill_in "Contacto", :with => "Yo soy tu hijo"
    fill_in "Fono", :with => "1234567"
    click_button "Actualizar"
    page.should_not have_content "Nuevo Cliente"
    page.should have_content "Patricio Flores" 
    page.should have_content "Yo soy tu hijo" 
    page.should have_content "1234567" 
    page.should_not have_content "Don francisco"
    page.should_not have_content "Que venga la modelo!!!"
    page.should_not have_content "24500-03"
  end

end