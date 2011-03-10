require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Crear Proyecto" do
  background do
    Fabricate(:cliente, :descripcion => "Perico")
    login
    click_link "Admin"
    click_link "Proyectos"
  end

  scenario "con los datos basicos" do
    click_link "Nuevo proyecto"
    fill_in "Descripcion", :with => "Proyecto Trilla"
    fill_in "Codigo", :with => "T3"
    fill_in "Estimacion", :with => "100"
    select "Perico", :from => "Cliente"
    click_button "Crear"
    page.should have_content("Mis Proyectos")
    page.should have_content("Proyecto Trilla")
    page.should have_content("Perico")
    click_link "Proyecto Trilla"
    field_labeled("Codigo").value.should == "T3"
    field_labeled("Estimacion").value.should == "100"
  end
end
