require 'httparty'
require 'json'

class SiriProxy::Plugin::PowerMonitor < SiriProxy::Plugin
  attr_accessor :host

  def initialize(config = {})
    self.host = config["host"]
  end

  #capture thermostat status
  listen_for(/power.*status/i) { show_power_usage }
  
  def show_power_usage
    say "Checking the inside temperature."
    
    Thread.new {
      page = HTTParty.get("http://#{self.host}/").body rescue nil
      status = JSON.parse(page) rescue nil
      
      if status
        say "#{status["totalwatts"]} are currently in use."      
      else
        say "Sorry, I could not connect to the power monitoring system."
      end
        
      request_completed #always complete your request! Otherwise the phone will "spin" at the user!
    }
  end
end