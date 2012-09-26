# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-powermonitor"
  s.version     = "0.0.1" 
  s.authors     = ["keatontaylor"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = %q{A power monitoring plugin for SiriProxy}
  s.description = %q{This is largely a demo plugin of a real-world implementation of SiriProxy}

  s.rubyforge_project = "siriproxy-powermonitor"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "httparty"
end
