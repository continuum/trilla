class ProyectosController < ApplicationController
  def index
    @proyectos = Proyecto.all
  end

  def show
    @proyecto = Proyecto.find(params[:id])
  end

  def new
    @proyecto = Proyecto.new
  end

  def edit
    @proyecto = Proyecto.find(params[:id])
  end

  def create
    @proyecto = Proyecto.new(params[:proyecto])
    @proyecto.cliente_id = params[:cliente]
    if @proyecto.save
      flash[:notice] = 'Proyecto was successfully created.'
      redirect_to(@proyecto)
    else
      render :action => "new"
    end
  end

  def update
    @proyecto = Proyecto.find(params[:id])
    @proyecto.cliente_id = params[:cliente]
    if @proyecto.update_attributes(params[:proyecto])
      flash[:notice] = 'Proyecto was successfully updated.'
      redirect_to(@proyecto)
    else
      render :action => "edit"
    end
  end
  
  def archive
    @proyecto = Proyecto.find(params[:id])
    archivado = true
    archivado = false if @proyecto.archivado
    if @proyecto.update_attributes({:archivado => archivado})
      @proyectos = Proyecto.all
      render :action => "index"
    else
      render :action => "index"
    end
  end
      
  def destroy
    @proyecto = Proyecto.find(params[:id])
    @proyecto.destroy
    redirect_to(proyectos_url)
  end
end
