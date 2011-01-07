require 'date'

class Temporizador < ActiveRecord::Base
  
  belongs_to :proyecto
  belongs_to :tarea
  belongs_to :usuario
  
  def self.find_por_usuario_fecha(usuario, fecha)
    find(:all, 
        :conditions => ["usuario_id = ? and temporizadors.start like ?",usuario.id, "#{fecha}%"], 
        :joins => ["left join proyectos on temporizadors.proyecto_id = proyectos.id",
                   "left join clientes on proyectos.cliente_id = clientes.id",
                   "left join tareas on temporizadors.tarea_id = tareas.id"])
  end

  def self.fechaActual() 
    return Time.new-3.hours
  end
  
  def display(accion)

    if (accion == 'list')
    
      if self.iniciado == 1
        
        f = Temporizador.fechaActual
        
        if (self.start == self.stop)
          segundos = (f - self.start).to_i
        else
          
          segundos1 = (f - self.start).to_i
          segundos2 = (f - self.stop).to_i
          segundos = (segundos1 - segundos2) + (f - self.updated_at).to_i;

        end 
      else
        segundos = (self.stop - self.start).to_i
      end
    
    else
    
      segundos = (self.stop - self.start).to_i    
    
    end
    
    minutos = (segundos/60).to_i
    horas   = (minutos/60).to_i
    dias    = (horas/24).to_i

    horas2 = "%02d" % (horas%24)
    minutos2 = "%02d" % (minutos%60)

    horas = (horas%24)
    minutos = (minutos%60)
    segundos = (segundos%60)
    
    #st = self.start.strftime('%H:%M:%S  %d/%m/%Y')
    #act = Time.now.strftime('%H:%M:%S  %d/%m/%Y')
    
    resultado =  "#{horas}:#{minutos}:#{segundos}:#{dias}"
    resultado2 = "#{horas2}:#{minutos2}"

    if self.iniciado == 1
      return "<a id=\"lnk_reloj-#{self.id}\" class=\"lnk_reloj\" href=\"javascript:;\" title=\"Detener\" style=\"text-decoration:none; font-weight:bold; color:blue;\">" + 
             "<span id=\"reloj-running\" title=\"#{self.id}\" style=\"display:none;\">#{resultado}</span>"+
             "<span id=\"reloj-running-display\">#{resultado2}</span>&nbsp;<img src=\"/images/stop.gif\" border=\"0\" style=\"vertical-align:middle;\"></a>"
    else
      return "<a id=\"lnk_reloj-#{self.id}\" class=\"lnk_reloj\" href=\"javascript:;\" title=\"Iniciar\" style=\"text-decoration:none; font-weight:bold;\">"+
             "<span id=\"reloj-#{self.id}\" title=\"#{self.id}\" style=\"display:none;\">#{resultado}</span>"+
             "<span>#{resultado2}</span>&nbsp;<img src=\"/images/start.png\"  border=\"0\" style=\"vertical-align:middle;\"></a>"
    end
  end

end