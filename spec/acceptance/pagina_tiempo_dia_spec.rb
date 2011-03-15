require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Pagina Tiempo - Dia" do
  background do
    Timecop.travel Date.new(2011, 03, 01)
    login
    click_link "Timesheet"
    click_link "Tiempo"
    click_link "Día"
  end

  after do
    Timecop.return
  end

  scenario "muestra la fecha actual y boton para enviar timesheet" do
    page.should have_content "2011-03-01"
    page.should have_button "Enviar para Aprobación"
  end
end
