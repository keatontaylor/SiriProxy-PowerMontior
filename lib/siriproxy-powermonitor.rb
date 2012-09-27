require 'httparty'
require 'json'

class SiriProxy::Plugin::PowerMonitor < SiriProxy::Plugin
  attr_accessor :host

  def initialize(config = {})
    self.host = config["host"]
  end

  #capture power status
  listen_for(/power.*status/i) { show_power_usage }
  listen_for(/power.*usage/i) { show_power_usage }
  
  
  def show_power_usage
    say "Checking."
    page = HTTParty.get("http://#{self.host}/").body rescue nil
    status = JSON.parse(page) rescue nil
    
    # convert the power to kW. 
    powerkW = status['totalwatts'].to_f() / 1000
    leg0kW = status["leg0"].to_f() / 1000
    leg1kW = status["leg1"].to_f() / 1000
    
    if status
      response = ask "#{ powerkW.round(2).to_s() } kW are currently in use. Would you like a full report?"
      if (response =~ /.*yes/i)
        say "#{ powerkW.round(2).to_s() } total. \n #{leg0kW.round(2).to_s()} from leg zero. \n #{leg1kW.round(2).to_s()} from leg one.", spoken: "Here is your report."
      else
        say "Okay."
      end
    end
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  
  end
end