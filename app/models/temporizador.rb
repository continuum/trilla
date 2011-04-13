require 'date'

class Temporizador < ActiveRecord::Base

  belongs_to :proyecto
  belongs_to :tarea
  belongs_to :usuario

  def self.find_por_usuario_fecha(usuario, fecha)
    find(:all,
        :conditions => ["usuario_id = ? and temporizadors.fecha_creacion between ? and ?", usuario.id, fecha, (fecha + 1.day)],
        :joins => ["left join proyectos on temporizadors.proyecto_id = proyectos.id",
                   "left join clientes on proyectos.cliente_id = clientes.id",
                   "left join tareas on temporizadors.tarea_id = tareas.id"])
  end
  
  def self.find_by_usuario_semana_groupby_proyectos(usuario, fecha)
      find(:all, 
           :select => "proyecto_id, cliente_id, tarea_id",
           :joins => ["left join proyectos on temporizadors.proyecto_id = proyectos.id",
                      "left join clientes on proyectos.cliente_id = clientes.id",
                      "left join tareas on temporizadors.tarea_id = tareas.id"],
           :conditions => ["usuario_id = ? and temporizadors.fecha_creacion between ? and ?", usuario.id, fecha.beginning_of_week, fecha.end_of_week],
           :group => "proyecto_id, cliente_id, tarea_id")
  end

  def self.find_by_usuario_dia_groupby_proyectos_sum(usuario, fecha)
      find(:all, 
           :select => "sum(minutos), proyectos.descripcion, proyecto_id, cliente_id, tarea_id",
           :joins => ["left join proyectos on temporizadors.proyecto_id = proyectos.id",
                      "left join clientes on proyectos.cliente_id = clientes.id",
                      "left join tareas on temporizadors.tarea_id = tareas.id"],
           :conditions => ["usuario_id = ? and temporizadors.fecha_creacion between ? and ?", usuario.id, fecha, (fecha + 1.day)],
           :group => "proyectos.descripcion, proyecto_id, cliente_id, tarea_id")
  end
  
  def self.find_by_usuario_semana(usuario, fecha)
      find(:all, 
           :joins => ["left join proyectos on temporizadors.proyecto_id = proyectos.id",
                      "left join clientes on proyectos.cliente_id = clientes.id",
                      "left join tareas on temporizadors.tarea_id = tareas.id"],
           :conditions => ["usuario_id = ? and temporizadors.fecha_creacion between ? and ?", usuario.id, fecha.beginning_of_week, fecha.end_of_week],
           :order => "id")
  end

  def self.fechaActual()
    #debe estar puesta la resta del timezone del usuario
    return Time.zone.now-3.hours
  end

  def format_horas()
    segundos = 0

    if !self.minutos.nil?
      segundos = self.minutos * 60
    end
  
    if (self.iniciado == 1)
      segundos += (Temporizador.fechaActual - self.start).to_i
    end

    lHrs = (segundos / 3600).to_i
    lMinutes = ((segundos / 60).to_i) - (lHrs * 60)
    if lMinutes == 60
      lMinutes = 0
      lHrs = lHrs + 1
    end
    logger.info "FORMAT_HORAS: %02d:%02d" % [lHrs, lMinutes]
    return "%02d:%02d" % [lHrs, lMinutes]
  end

end
