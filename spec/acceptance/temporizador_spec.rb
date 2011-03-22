require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Temporizador" do
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
    click_link "Tiempo"
  end

  scenario "iniciando y parando el reloj" do
    click_link "Agregar Entrada"
    select "Enterprisey", :from => "Cliente/Proyecto"
    select "Desarrollo", :from => "Actividad"
    click_button "Iniciar"
    page.should have_clock_running
    click_stop_clock_button
    page.should have_no_clock_running
    page.should have_content "00:00"
  end

  scenario "iniciando el reloj con un valor pre-existente" do
    click_link "Agregar Entrada"
    select "Enterprisey", :from => "Cliente/Proyecto"
    select "Desarrollo", :from => "Actividad"
    fill_in "Horas:Minutos", :with => "1:15"
    click_button "Guardar"
    page.should have_clock_running
    click_stop_clock_button
    page.should have_no_clock_running
    page.should have_content "1:15"
  end

  scenario "iniciando el reloj, saliendo del sistema y deteniendolo mas tarde" do
    click_link "Agregar Entrada"
    select "Enterprisey", :from => "Cliente/Proyecto"
    select "Desarrollo", :from => "Actividad"
    click_button "Iniciar"
    page.should have_clock_running
    logout
    Timecop.travel 15.minutes.from_now do
      login
      click_link "Timesheet"
      page.should have_clock_running
      click_stop_clock_button
      page.should have_no_clock_running
      page.should have_content "0:15"
    end
  end

  scenario "al iniciar un reloj se detienen los otros" do
    preparando_cafe = Fabricate(
      :temporizador, :usuario => usuario, :tarea => Fabricate(:tarea),
      :descripcion => "Preparando café", :start => Date.today,
      :minutos => 5
    )
    lecture_and_beer = Fabricate(
      :temporizador, :usuario => usuario, :tarea => Fabricate(:tarea),
      :descripcion => "Lecture & beer", :start => Date.today,
      :minutos => 10
    )
    click_link "Día"
    page.should have_no_clock_running
    click_start_timer preparando_cafe
    page.should have_timer_running(preparando_cafe)
    page.should have_no_timer_running(lecture_and_beer)
    click_start_timer lecture_and_beer
    page.should have_timer_running(lecture_and_beer)
    page.should have_no_timer_running(preparando_cafe )
  end
end