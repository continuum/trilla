class TimesheetController < ApplicationController

  def index
    
    @clientesProyectos = Array.new

    Cliente.all.each do |cli|

      c = ClienteObj.new
      c.id = cli.id
      c.descripcion = cli.descripcion
      c.proyectos = Proyecto.find(:all, :conditions => ["cliente_id = ?", cli.id])

      @clientesProyectos << c
      
    end

    @tareas_facturables = Tarea.find_facturables()
    @tareas_no_facturables = Tarea.find_no_facturables()

    @fecha = params[:fecha]
    
    if @fecha.blank?
      @fecha = Temporizador.fechaActual().to_date()
    end

    @usuario = session[:usuario]
    @temporizadores = Temporizador.find_por_usuario_fecha(@usuario, @fecha)
    
  end

  def create
    
    iniciado = params[:iniciado]

    fechaActual = Temporizador.fechaActual()

    @tempo = Temporizador.new(params[:temporizador])
    @tempo.iniciado = iniciado
    @tempo.start = fechaActual
    @tempo.stop = fechaActual
    @tempo.save
    
    @fecha = params[:fecha]
    
    if @fecha.blank?
      @fecha = fechaActual.to_date()
    end

    @usuario = session[:usuario]
    @temporizadores = Temporizador.find_por_usuario_fecha(@usuario, @fecha)
    
    render(:file => 'timesheet/create' )

  end

  def edit

    @tempo = Temporizador.find(params[:id])
    @tempo.update_attributes(params[:temporizador])
    
    fechaActual = Temporizador.fechaActual()
    
    @fecha = params[:fecha]
    
    if @fecha.blank?
      @fecha = fechaActual.to_date()
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
#      else
#        if @tempo.iniciado == 1
#          @tempo.update_attributes({:stop => stop})
#        end
      end  
      
      #retorno = {:success => true, :msg => "tempo encontrado", :tempo => @tempo, :display => @tempo.display()}
      
    rescue ActiveRecord::RecordNotFound
      
      #retorno = {:success => false, :msg => "tempo no encontrado"}
      
    end
    
    render(:file => 'timesheet/update' )

  end

  def delete
    @temporizador = Temporizador.find(params[:id])
    @temporizador.destroy
    render :json => {:msg => 'ok', :success => true}
  end

end
