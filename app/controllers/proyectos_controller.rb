class ProyectosController < ApplicationController
  before_filter :authorizate_admin
  
  def index
    @proyectos = Proyecto.find_all_accesibles session[:usuario_id]
  end

  def show
    @proyecto = Proyecto.find(params[:id])
  end

  def new
    @proyecto = Proyecto.new
    @tareas = @proyecto.tareas
    @usuarios = @proyecto.usuarios
  end

  def edit
    @proyecto = Proyecto.find(params[:id])
    @tareas = @proyecto.tareas
    @usuarios = @proyecto.usuarios
  end


  def email_sent(proyecto)
    proyecto.usuarios.all.each do |usuario|
      Notifier::deliver_mail(usuario.email, url_for(proyecto))
    end
  end

  def create
    @proyecto = Proyecto.new(params[:proyecto])
    if @proyecto.save
      flash[:notice] = 'Proyecto was successfully created.'
      email_sent(@proyecto)
      redirect_to(proyectos_url)
    else
      render :action => "new"
    end
  end

  def update
    @proyecto = Proyecto.find(params[:id])
    @proyecto.cliente_id = params[:cliente]
    if @proyecto.update_attributes(params[:proyecto])
      flash[:notice] = 'Proyecto was successfully updated.'
      email_sent(@proyecto)
      redirect_to(proyectos_url)
    else
      render :action => "edit"
    end
  end

  def restore
    @proyecto = @proyecto = Proyecto.find(params[:id])
    @proyecto.restore
    redirect_to(proyectos_url)
  end

  def archive
    @proyecto = Proyecto.find(params[:id])
    @proyecto.archive
    redirect_to(proyectos_url)
  end

  def destroy
    @proyecto = Proyecto.find(params[:id])
    @proyecto.destroy
    redirect_to(proyectos_url)
  end
end
