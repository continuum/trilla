require 'spec_helper' 

context 'como usuario en la página de inicio' do 

  let(:user) { Factory(:user) } 

  before do 
    visit root_path 
  end 

  context 'con credenciales válidas' do 

    before do 
      fill_in 'Email', :with => 'abraham.barrera' 
      fill_in 'Passwd', :with => 'wenalicon43' 
      click 'Sign in' 
    end 

    it 'veo link de cierre sesión' do 
      page.should have_xpath('//a', :text => 'Sign Out') 
    end 

    it 'sabe quien soy' do 
      page.should have_content("abraham.barrera@continuum.cl") 
    end 

  end 

end

