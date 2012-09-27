require 'httparty'
require 'json'

class SiriProxy::Plugin::PowerMonitor < SiriProxy::Plugin
  attr_accessor :host

  def initialize(config = {})
    self.host = config["host"]
  end

  #capture thermostat status
  listen_for(/.*detailed power usage/i) { detailed_power_usage }
  listen_for(/power.*status/i) { show_power_usage }
  listen_for(/.*power usage/i) { show_power_usage }
  listen_for(/current.*power usage/i) { show_power_usage }
  
  
  def show_power_usage
    say "Checking the current power usage."

    Thread.new {
      page = HTTParty.get("http://#{self.host}/").body rescue nil
      status = JSON.parse(page) rescue nil
    
      powerkW = status['totalwatts'].to_f() / 1000
      if status
        say "#{ powerkW.round(2).to_s() } kW are currently in use."
        response = ask "Would you like a more detailed report?"
        if(response =~ /.*yes/i) #process their response
            leg0kW = status["leg0"].to_f() / 1000
            leg1kW = status["leg1"].to_f() / 1000
            say "#{leg0kW.round(2).to_s()} from leg zero. #{leg1kW.round(2).to_s()} from leg one."
        end    
      else
        say "Sorry, I could not connect to the power monitoring system."
      end
        
      request_completed #always complete your request! Otherwise the phone will "spin" at the user!
    }
  end
  
  def detailed_power_usage
     say "Getting a detailed report of power usage."

     Thread.new {
       page = HTTParty.get("http://#{self.host}/").body rescue nil
       status = JSON.parse(page) rescue nil
       
       totalkW = status['totalwatts'].to_f() / 1000
       leg0kW = status["leg0"].to_f() / 1000
       leg1kW = status["leg1"].to_f() / 1000

       if status
         say "#{totalkW.round(2).to_s()} kW total." 
         say "#{leg0kW.round(2).to_s()} from leg zero."
         say "#{leg1kW.round(2).to_s()} from leg one."      
       else
         say "Sorry, I could not connect to the power monitoring system."
       end

       request_completed #always complete your request! Otherwise the phone will "spin" at the user!
     }
   end
end