class InitController < ApplicationController
  
  def login
    if request.post?
      usuario = Usuario.autenticar(params[:name], params[:password])
      if usuario
        session[:login] = usuario.rut
        session[:usuario_id] = usuario.id
        session[:usuario] = usuario
        session[:usuario_perfil] = usuario.perfil
        redirect_to(:controller=>'timesheet', :action => "index" )
      else
        flash.now[:notice] = "Combinación usuario/password incorrectos"
      end
    end
  end
  
  def index
    redirect_to(:controller=>'timesheet', :action => "index" )
  end

end
