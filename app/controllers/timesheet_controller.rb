class TimesheetController < ApplicationController
  def index
    @clientesProyectos = Cliente.all.map do |cli|
      ClienteObj.new.tap do |c|
        c.id = cli.id
        c.descripcion = cli.descripcion
        c.proyectos = Proyecto.find(:all, :conditions => ["cliente_id = ? and not archivado = ?", cli.id, true])
      end
    end
    @tareas_facturables = Tarea.facturables
    @tareas_no_facturables = Tarea.no_facturables
    @fecha = params[:fecha]
    @fecha = Temporizador.fechaActual().to_date() if @fecha.blank?
    @usuario = session[:usuario]
    @temporizadores = Temporizador.find_por_usuario_fecha(@usuario, @fecha)
  end

  def create
    iniciado = params[:iniciado]
    fecha_actual = Temporizador.fechaActual()
    @tempo = Temporizador.new(params[:temporizador])
    @tempo.iniciado = iniciado
    @tempo.start = fecha_actual
    @tempo.stop = fecha_actual
    @tempo.save
    @fecha = params[:fecha]
    if @fecha.blank?
      @fecha = fecha_actual.to_date()
    end
    @usuario = session[:usuario]
    @temporizadores = Temporizador.find_por_usuario_fecha(@usuario, @fecha)
    render(:file => 'timesheet/create' )
  end

  def edit
    @tempo = Temporizador.find(params[:id])
    @tempo.update_attributes(params[:temporizador])
    fecha_actual = Temporizador.fechaActual()
    @fecha = params[:fecha]
    if @fecha.blank?
      @fecha = fecha_actual.to_date()
    end
    @usuario = session[:usuario]
    @temporizadores = Temporizador.find_por_usuario_fecha(@usuario, @fecha)
    render(:file => 'timesheet/create' )
  end
 
  def update
    @tempo = Temporizador.find(params[:id])
    begin
      tiempos = params[:time].to_s.split(':')
      stop = @tempo.start + (tiempos[0].to_i.hours + tiempos[1].to_i.minutes + tiempos[2].to_i.seconds + tiempos[3].to_i.days) 
      if (params[:accion] == 'start')
        @tempo.update_attributes({:stop => stop, :iniciado => 1})
      elsif (params[:accion] == 'stop')  
        @tempo.update_attributes({:stop => stop, :iniciado => 0})
      end  
    rescue ActiveRecord::RecordNotFound
    end
    render(:file => 'timesheet/update' )
  end

  def delete
    @temporizador = Temporizador.find(params[:id])
    @temporizador.destroy
    render :json => {:msg => 'ok', :success => true}
  end
end
