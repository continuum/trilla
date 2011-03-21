class TimesheetController < ApplicationController

  def index
      redirect_to :action => :day
  end

  def mobile
    self.day
    render(:file => 'timesheet/mobile', :layout => 'mobile')
  end

  def about
    render(:file => 'timesheet/about', :layout => 'mobile')
  end

  def mobtracking
    @fecha = Temporizador.fechaActual().to_date()
    @usuario = session[:usuario]
    @temporizadores = Temporizador.find_por_usuario_fecha(@usuario, @fecha)
    render(:file => 'timesheet/mobtracking', :layout => 'mobile')
  end

  def mobedit
    render(:file => 'timesheet/mobedit', :layout => 'mobile')
  end

  def mobweekly

  end

  def mobabout

  end


  def day
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

  def week

  end

  def create
    iniciado = params[:iniciado]
    minutos = 0
    if !params[:tiempo_base].blank?
      tiempo_base = params[:tiempo_base].split(":")
      horas = tiempo_base[0];
      minutos = horas.to_i * 60 + tiempo_base[1].to_i;
    end
    fecha_actual = Temporizador.fechaActual()
    @tempo = Temporizador.new(params[:temporizador])
    @tempo.iniciado = iniciado
    @tempo.minutos = minutos
    @tempo.start = fecha_actual
    @tempo.stop = fecha_actual
    @tempo.save
    if params[:fecha]
      @fecha = Date.parse params[:fecha]
    else
      @fecha = fecha_actual.to_date
    end
    @usuario = session[:usuario]
    @temporizadores = Temporizador.find_por_usuario_fecha(@usuario, @fecha)
    render(:file => 'timesheet/create' )
  end

  def edit
    minutos = 0
    if !params[:tiempo_base].blank?
      tiempo_base = params[:tiempo_base].split(":")
      horas = tiempo_base[0];
      minutos = horas.to_i * 60 + tiempo_base[1].to_i;
    end
    @tempo = Temporizador.find(params[:id])
    @tempo.minutos = minutos
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
      fecha = Temporizador.fechaActual
      if (params[:accion] == 'start')
        @tempo.update_attributes({:stop => fecha, :start => fecha, :iniciado => 1})
      elsif (params[:accion] == 'stop')
        minutos = @tempo.minutos + ((Temporizador.fechaActual - @tempo.start).to_i / 60).to_i
        @tempo.update_attributes({:stop => fecha, :iniciado => 0, :minutos => minutos})
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
