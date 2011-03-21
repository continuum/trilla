require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Pagina Tiempo" do
  background do
    login
    click_link "Timesheet"
    click_link "Tiempo"
  end

  scenario "muestra las opciones Dia y Semana" do
    page.should have_selected_tab "Día"
    page.should have_unselected_tab "Semana"
  end
end
