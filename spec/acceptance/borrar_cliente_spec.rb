require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Borrar Cliente" do
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
  
  scenario "sin proyectos" do
    page.evaluate_script("window.alert = function(msg) { return true; }")
    page.evaluate_script("window.confirm = function(msg) { return true; }")
    within_cliente_row(mario) do
      click_link "Eliminar"
    end
    page.should_not have_cliente mario
    page.should have_content "No existen clientes creados"
  end

  scenario "con proyectos asociados" do
    proyecto = Fabricate(:proyecto,
      :cliente => mario
    )
    page.evaluate_script("window.alert = function(msg) { return true; }")
    page.evaluate_script("window.confirm = function(msg) { return true; }")
    within_cliente_row(mario) do
      click_link "Eliminar"
    end
    page.should have_cliente mario
    page.should_not have_content "No existen clientes creados"
    page.should have_content "El cliente posee proyectos asociados"
  end

end