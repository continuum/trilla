class TimesheetController < ApplicationController
  
  include TimesheetHelper
  
  expose(:fecha_actual) { Temporizador.fechaActual }

  expose(:fecha) do
    if params[:fecha] && params[:fecha].present?
      Date.parse params[:fecha]
    else
      fecha_actual.to_date
    end
  end

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
    @usuario = session[:usuario]
    @temporizadores = Temporizador.find_por_usuario_fecha(@usuario, fecha)
    render(:file => 'timesheet/mobtracking', :layout => 'mobile')
  end

  def mobedit
    render(:file => 'timesheet/mobedit', :layout => 'mobile')
  end

  def mobweekly

  end

  def mobabout

  end

  def nuevoTemporizador
    
     @clientesProyectos = Cliente.all.map do |cli|
      ClienteObj.new.tap do |c|
        c.id = cli.id
        c.descripcion = cli.descripcion
        c.proyectos = Proyecto.find(:all, :conditions => ["cliente_id = ? and not archivado = ?", cli.id, true])
      end
    end
    @tareas_facturables = Tarea.facturables
    @tareas_no_facturables = Tarea.no_facturables
    
  end

  def day
    self.nuevoTemporizador
    @usuario = session[:usuario]
    @temporizadores = Temporizador.find_por_usuario_fecha(@usuario, fecha)
  end

  def week
    
    logger.info "semana actual #{fecha} desde: #{fecha.beginning_of_week} hasta: #{fecha.end_of_week}"
    @usuario = session[:usuario]

    @listaDias = Array.new
    @clientesProyectosTareas = Hash.new
    @clientesProyectosTareasSuma = Hash.new
    @dataPorDia = Hash.new

    #se crea una hash con todos los nombres de los proyectos (cliente/proyecto/tarea)
    Temporizador.find_by_usuario_semana_groupby_proyecto(@usuario, fecha).each do |t|
        descripcion = "<b>#{t.proyecto.cliente.descripcion}</b> / #{t.proyecto.descripcion}<br>#{t.tarea.descripcion}"
        llave_combinacion = "#{t.proyecto.cliente.id};#{t.proyecto.id};#{t.tarea.id}"
        @clientesProyectosTareas[descripcion] = llave_combinacion
    end

    #se recorren los 5 dias de la semana, se crea una matriz por cada dia y cliente/proyecto
    7.times { |i|

      dia = fecha.beginning_of_week + i.day 
      
      @listaDias << dia
      
      #se inicializan todos los valores para el dia en 0
      @clientesProyectosTareas.each do |descripcion, llave_combinacion|
        @dataPorDia["#{llave_combinacion}-#{dia}"] = 0
      end
  
      sumaDelDia = 0
  
      #se buscan los valores del dia
      Temporizador.find_by_usuario_dia_groupby_proyectos_sum(@usuario, dia).each do |t|
          llave_combinacion = "#{t.proyecto.cliente.id};#{t.proyecto.id};#{t.tarea.id}"
          @dataPorDia["#{llave_combinacion}-#{dia}"] = t.sum
          sumaDelDia+=t.sum.to_i
      end
      
      @dataPorDia["sumaDelDia-#{dia}"] = sumaDelDia
    }
    
    @sumaTotal = 0
    @clientesProyectosTareas.each do |descripcion, llave_combinacion|
      
      suma = 0;
      @listaDias.each do | dia |
        suma+= @dataPorDia["#{llave_combinacion}-#{dia}"].to_i
      end
    
      @clientesProyectosTareasSuma[llave_combinacion] = suma
      @sumaTotal+= suma
    end

  end

  def create
    iniciado = params[:iniciado]
    minutos = 0
    if !params[:tiempo_base].blank?
      tiempo_base = params[:tiempo_base].split(":")
      horas = tiempo_base[0];
      minutos = horas.to_i * 60 + tiempo_base[1].to_i;
    end

    @tempo = Temporizador.new(params[:temporizador])
    @tempo.iniciado = iniciado
    @tempo.minutos = minutos
    @tempo.start = fecha_actual
    @tempo.stop = fecha_actual
    @tempo.fecha_creacion = fecha
    @tempo.save
    @usuario = session[:usuario]
    @temporizadores = Temporizador.find_por_usuario_fecha(@usuario, fecha)
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
    @usuario = session[:usuario]
    @temporizadores = Temporizador.find_por_usuario_fecha(@usuario, fecha)
    render(:file => 'timesheet/create' )
  end

  def update
    @tempo = Temporizador.find(params[:id])
    begin
      if (params[:accion] == 'start')
        @tempo.update_attributes({:stop => fecha_actual, :start => fecha_actual, :iniciado => 1})
      elsif (params[:accion] == 'stop')
        minutos = @tempo.minutos + ((fecha_actual - @tempo.start).to_i / 60).to_i
        @tempo.update_attributes({:stop => fecha_actual, :iniciado => 0, :minutos => minutos})
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
  
  def approval

    @usuario = session[:usuario]
    
    Temporizador.update_estado_for_usuario_semana(@usuario, fecha,'POR_APROVAR')

    redirect_to :action => :week
    
  end
  
  def deleteRowWeek
  
    @usuario = session[:usuario]

    Temporizador.delete_by_usuario_semana_groupby_proyecto(@usuario, fecha, params[:filtro])
    
    redirect_to :action => :week
    
  end
  
  def addRowWeek
   
    self.nuevoTemporizador
    render(:file => 'timesheet/addrowweek' )
    
  end
  
  def newRowWeek
   
    @usuario = session[:usuario]
    row_week = params[:row_week]
    logger.info "row_week: #{row_week}"

    7.times { |i|

      dia = fecha.beginning_of_week + i.day
        
      t = Temporizador.new(params[:row_week])
      t.usuario_id = @usuario.id
      t.descripcion = '';
      t.iniciado = 0
      t.minutos = 1
      t.start = fecha_actual
      t.stop = fecha_actual
      t.fecha_creacion = dia
      t.save
    }    

    redirect_to :action => :week
    
  end
  
end
