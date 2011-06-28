require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Perfil Api Key" do
  let!(:pepito) {usuario}
   
  background do
    login(pepito)
    click_link pepito.nombres
  end

  scenario "Asignación de Api Key" do
    page.should have_content "Necesitas una Key para hacer llamadas al API de Trilla"
    click_link "[Obtener Key]"
    page.should have_content "Tu API Key:"
    page.should have_link "re-generar"
    page.should have_link "deshabilitar"
    click_link "deshabilitar"
    page.should have_content "Necesitas una Key para hacer llamadas al API de Trilla"
  end

end
 
     
