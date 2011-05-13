require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Rutas de temporizador" do

  background do
    login
  end

  scenario "ingresando al root de la apicacion" do
    page.should have_content Date.today.to_s
  end

  scenario "viendo entradas del 4/05/2011" do
    fecha = Date.strptime '4/05/2011', '%d/%m/%Y'
    visit "/timesheet/day/#{fecha.yday}/#{fecha.year}"
    page.should have_content "4/05/2011"
  end

  scenario "viendo siguiente día del 31/12/2011" do
    fecha = Date.strptime '31/12/2011', '%d/%m/%Y'
    visit "/timesheet/day/#{fecha.yday}/#{fecha.year}"
    click_link ">>"
    page.should have_content "01/01/2012"
  end

  scenario "viendo día anterior al 1/3/2008" do
    fecha = Date.strptime '1/3/2008', '%d/%m/%Y'
    visit "/timesheet/day/#{fecha.yday}/#{fecha.year}"
    click_link "<<"
    page.should have_content "29/02/2008"
  end

  scenario "Ingresando una fecha inválida" do
    visit "/timesheet/day/366/2011"
    page.should have_content "Fecha inválida. Cargando fecha de hoy por defecto"
    page.should have_content Date.today.to_s
  end

end