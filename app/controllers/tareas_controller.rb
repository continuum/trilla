class TareasController < ApplicationController
  before_filter :authorizate_admin

  def index
    @tareas = Tarea.all
  end

  def new
    @tarea = Tarea.new
  end

  def edit
    @tarea = Tarea.find(params[:id])
  end

  def create
    @tarea = Tarea.new(params[:tarea])
    if @tarea.save
      flash[:notice] = 'Tarea was successfully created.'
      redirect_to(tareas_url)
    else
      render :action => "new"
    end
  end

  def update
    @tarea = Tarea.find(params[:id])
    if @tarea.update_attributes(params[:tarea])
      flash[:notice] = 'Tarea was successfully updated.'
      redirect_to(tareas_url)
    else
      render :action => "edit"
    end
  end

  def destroy
    @tarea = Tarea.find(params[:id])
    if @tarea.destroy
      redirect_to(tareas_url)
    else
      flash[:error] = 'No se puede borrar una tarea que está relacionada a un proyecto'
      redirect_to(tareas_url)
    end
  end

end
