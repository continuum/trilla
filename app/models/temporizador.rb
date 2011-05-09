require 'date'

class Temporizador < ActiveRecord::Base

  belongs_to :proyecto
  belongs_to :tarea
  belongs_to :usuario

  validates_numericality_of :proyecto_id, :greater_than => 0, :message => "Debe seleccionar un proyecto"
  validates_numericality_of :tarea_id, :greater_than => 0, :message => "Debe seleccionar una tarea"
  validates_numericality_of :usuario_id, :greater_than => 0, :message => "Temporizador no tiene asociado un usuario"
  
  def self.find_por_usuario_fecha(usuario, fecha)
    find(:all,
        :conditions => ["usuario_id = ? and temporizadors.fecha_creacion between ? and ?", usuario.id, fecha, (fecha + 1.day)],
        :joins => ["left join proyectos on temporizadors.proyecto_id = proyectos.id",
                   "left join clientes on proyectos.cliente_id = clientes.id",
                   "left join tareas on temporizadors.tarea_id = tareas.id"])
  end
  
  def self.find_by_usuario_semana_groupby_proyecto(usuario, fecha, filtro = {})
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
  
  def self.update_estado_for_usuario_semana(usuario, fecha, estado)
      
      update_all("estado = '#{estado}'", ["usuario_id = ? and fecha_creacion between ? and ?", usuario.id, fecha.beginning_of_week, fecha.end_of_week])
      
  end
  
  def self.delete_by_usuario_semana_groupby_proyecto(usuario, fecha, filtro = {})
    
    condiciones = nil
    
    if filtro.empty?
      condiciones = ["usuario_id = ? and fecha_creacion between ? and ?", usuario.id, fecha.beginning_of_week, fecha.end_of_week]
    else

      filtros = "";

      if !filtro[:proyecto_id].nil?
        filtros+= " and proyecto_id = #{filtro[:proyecto_id]}"
      end
      
      if !filtro[:tarea_id].nil?
        filtros+= " and tarea_id = #{filtro[:tarea_id]}"
      end
      
      condiciones = ["usuario_id = ? #{filtros} and fecha_creacion between ? and ?", usuario.id, fecha.beginning_of_week, fecha.end_of_week]
    end
    
    delete_all(condiciones)
    
  end
  
  def format_horas()
    segundos = 0

    if !self.minutos.nil?
      segundos = self.minutos * 60
    end
  
    if (self.iniciado == 1)
      segundos += (Time.now - self.start).to_i
    end

    lHrs = (segundos / 3600).to_i
    lMinutes = ((segundos / 60).to_i) - (lHrs * 60)
    if lMinutes == 60
      lMinutes = 0
      lHrs = lHrs + 1
    end

    return "%02d:%02d" % [lHrs, lMinutes]
  end

end
