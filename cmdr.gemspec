Gem::Specification.new do |s|
  s.name = 'cmdr'
  s.version = '0.4.1'
  s.summary = 'cmdr'
  s.authors = ['James Robertson']
  s.files = Dir['lib/cmdr.rb']
  s.signing_key = '../privatekeys/cmdr.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/cmdr'
  s.required_ruby_version = '>= 2.1.2'
end
