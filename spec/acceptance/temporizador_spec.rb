require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Reportar horas" do
  let!(:desarrollo) { Fabricate(:tarea, :descripcion => "Desarrollo") }
  let!(:megabank) { Fabricate(:cliente, :descripcion => "Mega Bank") }
  let!(:enterprisey) do
    Fabricate(
      :proyecto, :descripcion => "Enterprisey", :cliente => megabank,
      :tareas => [desarrollo]
    )
  end

  background do
    login
    click_link "Timesheet"
  end

  scenario "iniciando y parando el reloj" do
    click_link "Agregar Entrada"
    select "Enterprisey", :from => "Cliente/Proyecto"
    select "Desarrollo", :from => "Actividad"
    click_button "Iniciar"
    page.should have_clock_running
    click_stop_clock_button
    page.should have_no_clock_running
  end
end
