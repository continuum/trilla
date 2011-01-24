class Notifier < ActionMailer::Base
  def mail(recipient, link)     
    recipients recipient
    subject    "[JarBest] Proyectos #{recipient}"
    body       :recipient => recipient, :link => link
  end  
end
