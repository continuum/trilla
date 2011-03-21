require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Pagina Tiempo - Dia" do
  background do
    login
    click_link "Timesheet"
    click_link "Tiempo"
  end

  scenario "muestra la fecha actual" do
    Timecop.travel(Date.new(2011, 03, 02)) do
      click_link "Día"
      page.should have_content "2011-03-02"
    end
  end

  scenario "muestra link para agregar entrada" do
    click_link "Día"
    page.should have_link "Agregar Entrada"
  end

  scenario "muestra las tareas del dia con reloj y opciones para eliminar y editar" do
    temporizador = Fabricate(
      :temporizador, :usuario => usuario, :tarea => Fabricate(:tarea),
      :descripcion => "Preparando café", :start => Date.today
    )
    click_link "Día"
    within_timer_row(temporizador) do
      page.should have_content "Preparando café"
      page.should have_link "Editar"
      page.should have_link "Borrar"
      page.should have_clock
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

  scenario "muestra botón para enviar aprobación" do
    click_link "Día"
    page.should have_button "Enviar para Aprobación"
  end
end
