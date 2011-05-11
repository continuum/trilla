require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Ver proyectos" do
  let!(:alguien) do
    Fabricate(:usuario,
      :nombres => "Alguien que puede ver un proyecto privado",
      :email => "alguien@continuum.cl",
      :perfil => "ADMIN"
    )
  end
  
  let!(:otro) do
    Fabricate(:usuario,
      :nombres => "Puedo ver solo proyectos publicos",
      :email => "otro@continuum.cl",
      :perfil => "ADMIN"
    )
  end
  
  let!(:publico) do
    Fabricate(:proyecto,
      :descripcion => "Todos me ven",
      :privado => false,
      :cliente => Fabricate(:cliente)
    )
  end
  
  let!(:privado) do
    Fabricate(:proyecto,
      :descripcion => "Alguien me ve",
      :privado => true,
      :cliente => Fabricate(:cliente),
      :usuarios => [alguien]
    )
  end
  
  scenario "con usuario sin proyecto asociado" do
    login otro
    click_link "Admin"
    click_link "Proyectos"
    page.should have_content "Todos me ven"
    page.should_not have_content "Alguien me ve"
  end
  
  scenario "con usuario con proyectos asociados" do
    login alguien
    click_link "Admin"
    click_link "Proyectos"
    page.should have_content "Todos me ven"
    page.should have_content "Alguien me ve"
  end
  
end
