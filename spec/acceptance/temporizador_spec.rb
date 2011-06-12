require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Temporizador" do
  let!(:perico) {usuario}
  let!(:desarrollo) { Fabricate(:tarea, :descripcion => "Desarrollo") }
  let!(:megabank) { Fabricate(:cliente, :descripcion => "Mega Bank", :contacto => "Farkas") }
  let!(:enterprisey) do
    Fabricate(
      :proyecto, 
      :descripcion => "Enterprisey", 
      :cliente => megabank,
      :usuarios => [perico],
      :tareas => [desarrollo]
    )
  end

  background do
    login(perico)
  end

  scenario "iniciando y parando el reloj" do
    click_link "Agregar Entrada"
    fill_in "Descripción", :with => "Inicio de proyecto"
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
      login(perico)
      click_link "Timesheet"
      page.should have_clock_running
      click_stop_clock_button
      page.should have_no_clock_running
      page.should have_content "0:15"
    end
  end

  scenario "al iniciar un reloj se detienen los otros" do
    preparando_cafe = Fabricate(
      :temporizador, :usuario => perico, :tarea => Fabricate(:tarea, :descripcion => "Cosas varias"),
      :descripcion => "Preparando café", :start => Time.now,
      :minutos => 5,:fecha_creacion => Time.now, :stop => Time.now,
      :iniciado => 0,
      :proyecto => enterprisey
    )
    lecture_and_beer = Fabricate(
      :temporizador, :usuario => perico, :tarea => Fabricate(:tarea, :descripcion => "Reunión"),
      :descripcion => "Lecture & beer", :start => Time.now,
      :minutos => 10,:fecha_creacion => Time.now, :stop => Time.now,
      :iniciado => 0,
      :proyecto => enterprisey
    )
    click_link "Día"
    page.should have_no_clock_running
    click_start_timer preparando_cafe
    page.should have_timer_running(preparando_cafe)
    page.should_not have_timer_running(lecture_and_beer)
    click_start_timer lecture_and_beer
    page.should have_timer_running(lecture_and_beer)
    page.should_not have_timer_running(preparando_cafe )
  end
  
  scenario "iniciando un reloj un día antes" do
    lo_que_hice_el_dia_anterior = Fabricate(
      :temporizador, :usuario => usuario, :tarea => desarrollo,
      :descripcion => "Esto lo hice ayer", :iniciado => 0, :start => Time.now - 1.day,
      :fecha_creacion => Time.now - 1.day, :stop => Time.now - 1.day,
      :proyecto => enterprisey
    )
    click_link "Día"
    page.should have_no_clock_running

    click_link "<<"
    page.should_not have_timer_running(lo_que_hice_el_dia_anterior)
    page.should have_content "Esto lo hice ayer"
    click_start_timer lo_que_hice_el_dia_anterior
    
    click_link ">>"
    page.should have_no_clock_running
    
    click_link "<<"
    page.should have_timer_running(lo_que_hice_el_dia_anterior)
    page.should have_content "Esto lo hice ayer"
  end
  
  scenario "mostrando aviso de advertencia de atrasos en temporizadores" do
    click_link "Agregar Entrada"
    select "Enterprisey", :from => "Cliente/Proyecto"
    select "Desarrollo", :from => "Tarea"
    click_button "Iniciar"
    Timecop.travel(Time.now + 17.hours + 59.minutes) do
      click_link "Timesheet"
      page.should_not have_content "Usted dejó timers corriendo. Favor de revisar"
    end
    Timecop.travel(Time.now + 18.hours + 1.minute) do
      click_link "Timesheet"
      page.should have_content "Usted dejó timers corriendo. Favor de revisar"
    end
  end
  
  scenario "Ingresando más caracteres de los permitidos en la descripción del temporizador." do 
    click_link "Agregar Entrada"
    select "Enterprisey", :from => "Cliente/Proyecto"
    select "Desarrollo", :from => "Tarea"
    fill_in "Descripción", :with => "0123456789" * 55
    click_button "Iniciar"
    page.should have_clock_running
  end

  scenario "Sumando horas en el campo de texto del tiempo." do
    click_link "Agregar Entrada"

    fill_in "Horas:Minutos", :with => "1:15+:45"
    fill_in "Descripción", :with => "Cambiando de foco del campo Horas:Minutos"
    find_field('Horas:Minutos').value == "02:00"

    fill_in "Horas:Minutos", :with => "1:15+1:45"
    fill_in "Descripción", :with => "Cambiando de foco del campo Horas:Minutos"
    find_field('Horas:Minutos').value == "03:00"

    fill_in "Horas:Minutos", :with => "1:15+:45+:20+2:00"
    fill_in "Descripción", :with => "Cambiando de foco del campo Horas:Minutos"
    find_field('Horas:Minutos').value == "04:20"
  end

  scenario "Restando horas en el campo de texto del tiempo." do
    click_link "Agregar Entrada"

    fill_in "Horas:Minutos", :with => "1:15-:45"
    fill_in "Descripción", :with => "Cambiando de foco del campo Horas:Minutos"
    find_field('Horas:Minutos').value == "00:30"

    fill_in "Horas:Minutos", :with => "1:15-1:45"
    fill_in "Descripción", :with => "Cambiando de foco del campo Horas:Minutos"
    find_field('Horas:Minutos').value == "00:00"

    fill_in "Horas:Minutos", :with => "1:15-:45-:20-0:05"
    fill_in "Descripción", :with => "Cambiando de foco del campo Horas:Minutos"
    find_field('Horas:Minutos').value == "00:05"
  end

  scenario "Sumando y restando en el campo de texto del tiempo." do
    click_link "Agregar Entrada"

    fill_in "Horas:Minutos", :with => "1:15-:45+:20-:10+2:05"
    fill_in "Descripción", :with => "Cambiando de foco del campo Horas:Minutos"
    find_field('Horas:Minutos').value == "02:45"
  end

end