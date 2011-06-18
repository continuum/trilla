require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Pagina Tiempo - Dia" do
  let!(:pepito) {usuario}
  let!(:desarrollo) { Fabricate(:tarea, :descripcion => "Desarrollo") }
  let!(:megabank) { Fabricate(:cliente, :descripcion => "Mega Bank", :contacto => "Farkas") }
  let!(:enterprisey) do
    Fabricate(
      :proyecto,
      :descripcion => "Enterprisey",
      :cliente => megabank,
      :usuarios => [pepito],
      :tareas => [desarrollo]
    )
  end

  background do
    login(pepito)
    click_link "Timesheet"
    click_link "Tiempo"
  end

  scenario "muestra la fecha actual" do
    Timecop.travel(Date.new(2011, 03, 02)) do
      click_link "Timesheet"
      page.should have_content "02/03/2011"
    end
  end

  scenario "muestra link para agregar entrada" do
    click_link "Día"
    page.should have_link "Agregar Entrada"
  end

  scenario "muestra las tareas del dia con reloj y opciones para eliminar y editar" do
    temporizador = Fabricate(
      :temporizador, :usuario => pepito, :tarea => desarrollo,
      :descripcion => "Preparando café 2", :start => Time.now,
      :fecha_creacion => Date.today, :stop => Time.now,
      :proyecto => enterprisey
    )
    click_link "Día"
    within_timer_row(temporizador) do
      page.should have_content "Preparando café"
      page.should have_link "Editar"
      page.should have_link "Borrar"
      page.should have_clock
    end
  end

  scenario "muestra botón para enviar aprobación" do
    click_link "Día"
    page.should have_button "Enviar para Aprobación"
  end
end

feature "Mostrar el total de horas del día" do
  let!(:pepito) {usuario}
  let!(:desarrollo) { Fabricate(:tarea, :descripcion => "Desarrollo") }
  let!(:megabank) { Fabricate(:cliente, :descripcion => "Mega Bank", :contacto => "Farkas") }
  let!(:enterprisey) do
    Fabricate(
      :proyecto,
      :descripcion => "Enterprisey",
      :cliente => megabank,
      :usuarios => [pepito],
      :tareas => [desarrollo]
    )
  end

  background do
    login(pepito)
    click_link "Timesheet"
    click_link "Tiempo"
  end

  scenario "Muestra el total de horas por día sin haber agregado ninguna tarea" do
    click_link "Día"
    within_total_hours_of_day do
      page.should have_content "00:00"
    end
  end

  scenario "Muestra el total de horas por día con una tarea agregada de 5 minutos" do
    tarea = Fabricate(
      :temporizador, :usuario => pepito, :tarea => Fabricate(:tarea, :descripcion => "Cosas varias"),
      :descripcion => "Preparando café", :start => Time.now,
      :minutos => 5,:fecha_creacion => Date.today, :stop => Time.now,
      :iniciado => 0,
      :proyecto => enterprisey
    )
    click_link "Día"
    within_total_hours_of_day do
      page.should have_content "00:05"
    end
  end

  scenario "Muestra el total de horas por día con tres tareas agregadas al inicio" do
    tarea1 = Fabricate(
      :temporizador, :usuario => pepito, :tarea => desarrollo,
      :descripcion => "Preparando café", :start => Time.now,
      :minutos => 5,:fecha_creacion => Date.today, :stop => Time.now,
      :iniciado => 0,
      :proyecto => enterprisey
    )
    tarea2 = Fabricate(
      :temporizador, :usuario => pepito, :tarea => desarrollo,
      :descripcion => "Leyendo el diario", :start => Time.now,
      :minutos => 70,:fecha_creacion => Date.today, :stop => Time.now,
      :iniciado => 0,
      :proyecto => enterprisey
    )
    tarea3 = Fabricate(
      :temporizador, :usuario => pepito, :tarea => desarrollo,
      :descripcion => "Jugando ping pong", :start => Time.now,
      :minutos => 124,:fecha_creacion => Date.today, :stop => Time.now,
      :iniciado => 0,
      :proyecto => enterprisey
    )
    click_link "Día"
    within_total_hours_of_day do
      # 124 + 70 + 5 = 199 minutos = 3 horas 19 minutos.
      page.should have_content "03:19"
    end
  end

  scenario "Actualiza las horas trabajadas del día cuando se borra una tarea" do
    tarea1 = Fabricate(
      :temporizador, :usuario => pepito, :tarea => desarrollo,
      :descripcion => "Preparando café", :start => Time.now,
      :minutos => 87,:fecha_creacion => Date.today, :stop => Time.now,
      :iniciado => 0,
      :proyecto => enterprisey
    )
    tarea2 = Fabricate(
      :temporizador, :usuario => pepito, :tarea => desarrollo,
      :descripcion => "Leyendo el diario", :start => Time.now,
      :minutos => 39,:fecha_creacion => Date.today, :stop => Time.now,
      :iniciado => 0,
      :proyecto => enterprisey
    )

    click_link "Día"
    page.evaluate_script("window.confirm = function(msg) { return true; }")
    within_timer_row(tarea2) do
      click_link "Borrar"
    end
    within_total_hours_of_day do
      page.should have_content "1:27"
    end
  end

  scenario "Actualiza las horas trabajadas del día cuando se agrega una tarea" do
    tarea1 = Fabricate(
      :temporizador, :usuario => pepito, :tarea => desarrollo,
      :descripcion => "Preparando café", :start => Time.now,
      :minutos => 87,:fecha_creacion => Date.today, :stop => Time.now,
      :iniciado => 0,
      :proyecto => enterprisey
    )
    click_link "Día"
    click_link "Agregar Entrada"
    fill_in "Descripción", :with => "Nueva tarea"
    select "Enterprisey", :from => "Cliente/Proyecto"
    select "Desarrollo", :from => "Tarea"
    fill_in "Horas:Minutos", :with => "1:15"
    click_button "Guardar"
    within_total_hours_of_day do
      page.should have_content "2:42"
    end
  end

  scenario "Actualiza las horas trabajadas del día cuando se modifica la hora de una tarea" do
    tarea1 = Fabricate(
      :temporizador, :usuario => pepito, :tarea => desarrollo,
      :descripcion => "Preparando café 1", :start => Time.now,
      :minutos => 87,:fecha_creacion => Date.today, :stop => Time.now,
      :iniciado => 0,
      :proyecto => enterprisey
    )
    tarea2 = Fabricate(
      :temporizador, :usuario => pepito, :tarea => desarrollo,
      :descripcion => "Preparando café 2", :start => Time.now,
      :minutos => 29,:fecha_creacion => Date.today, :stop => Time.now,
      :iniciado => 0,
      :proyecto => enterprisey
    )
    click_link "Día"
    within_timer_row(tarea2){ click_link "Editar" }
    fill_in "Horas:Minutos", :with => "1:15"
    click_button "Guardar"
     within_total_hours_of_day do
      page.should have_content "2:42"
    end
  end

  scenario "Actualiza las horas trabajadas del día cuando se detiene el timer de alguna tarea" do
    tarea1 = Fabricate(
      :temporizador, :usuario => pepito, :tarea => desarrollo,
      :descripcion => "Preparando café 1", :start => Time.now,
      :minutos => 87,:fecha_creacion => Date.today, :stop => Time.now,
      :iniciado => 0,
      :proyecto => enterprisey
    )
    click_link "Día"
    click_start_timer tarea1
    page.should have_clock_running
    Timecop.travel 15.minutes.from_now do
      click_stop_clock_button
      within_total_hours_of_day do
        page.should have_content "01:42"
      end
    end
  end
end
