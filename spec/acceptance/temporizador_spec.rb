require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Temporizador" do
  let!(:pepito) {usuario}
  let!(:desarrollo) { Fabricate(:tarea, :descripcion => "Desarrollo") }
  let!(:megabank) { Fabricate(:cliente, :descripcion => "Mega Bank") }
  let!(:enterprisey) do
    Fabricate(
      :proyecto, :descripcion => "Enterprisey", :cliente => megabank,
      :tareas => [desarrollo]
    )
  end

  background do
    login(pepito)
    click_link "Timesheet"
    click_link "Tiempo"
  end

  scenario "iniciando y parando el reloj" do
    click_link "Agregar Entrada"
    select "Enterprisey", :from => "Cliente/Proyecto"
    select "Desarrollo", :from => "Tarea"
    click_button "Iniciar"
    page.should have_clock_running
    click_stop_clock_button
    page.should have_no_clock_running
    page.should have_content "00:00"
  end

  scenario "iniciando el reloj con un valor pre-existente" do
    click_link "Agregar Entrada"
    select "Enterprisey", :from => "Cliente/Proyecto"
    select "Desarrollo", :from => "Tarea"
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
    select "Desarrollo", :from => "Tarea"
    click_button "Iniciar"
    page.should have_clock_running
    logout
    Timecop.travel 15.minutes.from_now do
      login(pepito)
      click_link "Timesheet"
      page.should have_clock_running
      click_stop_clock_button
      page.should have_no_clock_running
      page.should have_content "0:15"
    end
  end

  scenario "al iniciar un reloj se detienen los otros" do
    preparando_cafe = Fabricate(
      :temporizador, :usuario => pepito, :tarea => Fabricate(:tarea, :descripcion => "Cosas varias"),
      :descripcion => "Preparando café", :start => Date.today,
      :minutos => 5,:fecha_creacion => Date.today, :stop => Date.today,
      :proyecto => enterprisey
    )
    lecture_and_beer = Fabricate(
      :temporizador, :usuario => pepito, :tarea => Fabricate(:tarea, :descripcion => "Reunión"),
      :descripcion => "Lecture & beer", :start => Date.today,
      :minutos => 10,:fecha_creacion => Date.today, :stop => Date.today,
      :proyecto => enterprisey
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
  
  scenario "iniciando un reloj un día antes" do
    lo_que_hice_el_dia_anterior = Fabricate(
      :temporizador, :usuario => usuario, :tarea => Fabricate(:tarea, :descripcion => "Cosas varias"),
      :descripcion => "Esto lo hice ayer", :iniciado => 0, :start => Date.today - 1.day,
      :fecha_creacion => Date.today - 1.day, :stop => Date.today - 1.day,
      :proyecto => Fabricate(:proyecto)
    )
    click_link "Día"
    page.should have_no_clock_running

    click_link "<<"
    page.should have_no_timer_running(lo_que_hice_el_dia_anterior)
    page.should have_content "Esto lo hice ayer"
    click_start_timer lo_que_hice_el_dia_anterior
    
    click_link ">>"
    page.should have_no_clock_running
    
    click_link "<<"
    page.should have_timer_running(lo_que_hice_el_dia_anterior)
    page.should have_content "Esto lo hice ayer"
  end
  
end