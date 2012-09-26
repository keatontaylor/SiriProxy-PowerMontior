require 'httparty'
require 'json'

class SiriProxy::Plugin::PowerMonitor < SiriProxy::Plugin
  attr_accessor :host

  def initialize(config = {})
    self.host = config["host"]
  end

  #capture thermostat status
  listen_for(/detailed.*power usage/i) { detailed_power_usage }
  listen_for(/power.*status/i) { show_power_usage }
  listen_for(/power.*usage/i) { show_power_usage }
  listen_for(/current.*power usage/i) { show_power_usage }
  
  
  def show_power_usage
    say "Checking the current power usage."
    
    Thread.new {
      page = HTTParty.get("http://#{self.host}/").body rescue nil
      status = JSON.parse(page) rescue nil
      
      if status
        say "#{status["totalwatts"]} watts are currently in use."      
      else
        say "Sorry, I could not connect to the power monitoring system."
      end
        
      request_completed #always complete your request! Otherwise the phone will "spin" at the user!
    }
  end
  
  def detailed_power_usage
     say "Checking the current power usage."

     Thread.new {
       page = HTTParty.get("http://#{self.host}/").body rescue nil
       status = JSON.parse(page) rescue nil

       if status
         say "#{status["totalwatts"]}  total watts, #{status["leg0"]} from leg zero, #{status["leg1"]} from leg one."      
       else
         say "Sorry, I could not connect to the power monitoring system."
       end

       request_completed #always complete your request! Otherwise the phone will "spin" at the user!
     }
   end
end