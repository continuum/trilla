require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Pagina Tiempo - Dia" do
  let!(:pepito) {usuario}
    
  background do
    login(pepito)
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
      :temporizador, :usuario => pepito, :tarea => Fabricate(:tarea),
      :descripcion => "Preparando café", :start => Temporizador.fechaActual,
      :fecha_creacion => Temporizador.fechaActual, :stop => Temporizador.fechaActual,
      :proyecto => Fabricate(:proyecto)
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
