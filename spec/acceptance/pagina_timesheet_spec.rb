require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Pagina Timesheet" do
  background do
    login
    click_link "Timesheet"
  end

  scenario "muestra opciones Tiempo, Por Aprobar y Archivo" do
    page.should have_link "Tiempo"
    page.should have_link "Por Aprobar"
    page.should have_link "Archivo"
  end
end
