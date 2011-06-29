class ApiController < ApplicationController
  include AuthenticationHelper
    
  def projects
    @clientesProyectos = Cliente.find_with_proyectos_by_usuario current_user.id
    respond_to do |format|
      format.json { render :json => @clientesProyectos }
    end
  end
  
  def tasks
    @clientesProyectos = Cliente.find_with_proyectos_by_usuario current_user.id
    @tareasProyecto = Tarea.find_by_clientes_proyectos @clientesProyectos
    respond_to do |format|
      format.json { render :json => @tareasProyecto }
    end
  end 
  
  def timesheets
    if params[:date] && params[:date].present?
      fecha = Date.strptime params[:date], "%d/%m/%Y"
    else
      fecha = Date.today
    end
    @temporizadores = Temporizador.find_por_usuario_fecha(current_user, fecha) 
    respond_to do |format|
      format.json { render :json => @temporizadores }
    end
  end
    
  
end
