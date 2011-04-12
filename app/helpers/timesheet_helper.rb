module TimesheetHelper
  
  def format_horas(minutos)
    segundos = 0

    if !minutos.nil?
      segundos = minutos * 60
    end

    lHrs = (segundos / 3600).to_i
    lMinutes = ((segundos / 60).to_i) - (lHrs * 60)
    if lMinutes == 60
      lMinutes = 0
      lHrs = lHrs + 1
    end

    return "%2d:%02d" % [lHrs, lMinutes]
  end
  
end
