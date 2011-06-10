require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Crear Proyecto" do
  
  background do
    Fabricate(:cliente, :descripcion => "Perico")
    login
    click_link "Admin"
    click_link "Proyectos"
  end

  scenario "sin datos" do
    click_link "Crear proyecto"
    click_button "Crear"
    page.should have_content("Debe ingresar un nombre para el proyecto")
    page.should have_content("Debe seleccionar un cliente")
  end
  
  scenario "con los datos básicos" do
    click_link "Crear proyecto"
    fill_in "Nombre", :with => "Proyecto Trilla"
    select "Perico", :from => "Cliente"
    click_button "Crear"
    page.should have_content("Proyecto Trilla")
    page.should_not have_content "Nuevo Proyecto"
    click_link "Proyecto Trilla"
    page.should have_select "proyecto_cliente_id", :selected =>"Perico"
  end

  scenario "con nombre previamente existente" do
    Fabricate(:proyecto,
      :descripcion => "Shuper Proyecto",
      :archivado => false,
      :cliente => Fabricate(:cliente, :descripcion => "Juanito")
    )
    click_link "Crear proyecto"
    fill_in "Nombre", :with => "Shuper Proyecto"
    select "Juanito"
    click_button "Crear"
    page.should have_content("Ya existe un proyecto con el mismo nombre")
  end
  
  scenario "con acceso privado sin usuarios" do
    Fabricate(:cliente, :descripcion => "Juanito")
    click_link "Crear proyecto"
    fill_in "Nombre", :with => "Shuper Proyecto"
    select "Juanito"
    check "Privado"
    click_button "Crear"
    page.should have_content "Debe asociar al menos un usuario a un proyecto privado"
  end

  scenario "con todos los datos" do
    #Inicio de variables
    perico = Fabricate(:usuario, :perfil => "ADMIN")
    jp = Fabricate(:usuario, :nombres => "JP", :email => "lala@aeiou.cl")
    desa = Fabricate(:tarea)
    lavar = Fabricate(:tarea, :descripcion => "Lavar la ropa")
    
    #logueo del usuario a seleccionar, para que luego salga listado dentro de los proyectos
    login perico
    click_link "Admin"
    click_link "Proyectos"
    
    #Creación del proyecto
    click_link "Crear proyecto"
    fill_in "Nombre", :with => "Proyecto Trilla"
    fill_in "Código", :with => "T3"
    fill_in "Estimación", :with => "100"
    check "Archivado"
    check "Privado"
    select "Perico", :from => "Cliente"
    select "Perico de los Palotes", :from => "proyecto_usuarios_select"
    select "Desarrollo", :from => "proyecto_tareas_select"
    click_link "Agregar Persona"
    click_link "Agregar Tarea"
    click_button "Crear"
    #Verificación de los datos del proyecto creado
    page.should have_content("Mis Proyectos")
    page.should have_content("Proyecto Trilla")
    page.should_not have_content "Debe asociar al menos un usuario a un proyecto privado"
    click_link "Proyecto Trilla"
    field_labeled("Código").value.should == "T3"
    field_labeled("Estimación").value.should == "100"
    page.should have_checked_field "Archivado"
    page.should have_select "Cliente", :selected =>"Perico"
    page.should have_xpath("//input[@class='proyecto_usuarios_hidden' and @value='#{perico.id}']")
    page.should_not have_xpath("//input[@class='proyecto_usuarios_hidden' and @value='#{jp.id}']")
    page.should have_xpath("//input[@class='proyecto_tareas_hidden' and @value='#{desa.id}']")
    page.should_not have_xpath("//input[@class='proyecto_tareas_hidden' and @value='#{lavar.id}']")
    
  end
  
  scenario "con un valor NO numérico en el campo estimación" do
    click_link "Crear proyecto"
    fill_in "Estimación", :with => "áéíóú"
    field_labeled("Estimación").value.should == ""
  end

  scenario "con un valor numérico en el campo estimación" do
    click_link "Crear proyecto"
    fill_in "Estimación", :with => "170"
    field_labeled("Estimación").value.should == "170"
  end

end
