require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Validar zona horaria" do
  let!(:chavo) do
    Fabricate(:usuario,
      :nombres => "Chavo del ocho",
      :email => "chavo@quebonitavecindad.co.mx",
      :time_zone => "Mexico City",
      :perfil => "ADMIN"
    )
  end
  
  background do
    login chavo
  end

  scenario "al mostrar una fecha de creación de proyecto" do
    ahora_chile = Time.zone.now
    Time.zone = "Mexico City"
    ahora_mexico = Time.zone.now
    jamon_finder = Fabricate(:proyecto,
      :descripcion => "Tortas de jamón finder",
      :cliente => Fabricate(:cliente, :descripcion => "Ron damon"),
      :created_at => ahora_chile
    )
    click_link "Admin"
    within_proyecto_row jamon_finder do
      page.should have_content ahora_mexico.to_s
    end
  end  

end
