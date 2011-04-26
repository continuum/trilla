require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Editar temporizador" do
  let!(:pepito) {usuario}
  let!(:tarea) { Fabricate(:tarea, :descripcion => "Reunion Interna") }
  let!(:internal) do
    Fabricate(
      :proyecto, :descripcion => "Internal", :tareas => [tarea],
      :cliente => Fabricate(:cliente, :descripcion => "Continuum")
    )
  end

  let!(:next_big_thing) do
    Fabricate(
      :proyecto, :descripcion => "Next Big Thing", :tareas => [tarea],
      :cliente => Fabricate(:cliente, :descripcion => "Secret")
    )
  end

  background do
    login(pepito)
    click_link "Timesheet"
    click_link "Tiempo"
  end

  scenario "temporizador existente" do
    lecture_and_beer = Fabricate(
      :temporizador, :usuario => pepito,
      :tarea => tarea, :proyecto => next_big_thing,
      :descripcion => "Lecture & beer", :start => Date.today,
      :minutos => 90,:fecha_creacion => Date.today, :stop => Date.today
    )
    click_link "Día"
    within_timer_row(lecture_and_beer) { click_link "Editar" }
    field_labeled("Cliente/Proyecto").value.should == next_big_thing.id.to_s
    field_labeled("Tarea").value.should == internal.id.to_s
    field_labeled("Horas:Minutos").value.should == "01:30"
    find_field('temporizador_descripcion').value.should == "Lecture & beer"
    select "Internal", :from => "Cliente/Proyecto"
    fill_in "Horas:Minutos", :with => "02:40"
    click_button "Guardar"
    click_link "Día"
    within_timer_row(lecture_and_beer) do
      page.should have_no_content "Next Big Thing"
      page.should have_no_content "01:30"
      page.should have_content "Internal"
      page.should have_content "02:40"
    end
  end
end
