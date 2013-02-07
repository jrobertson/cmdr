Gem::Specification.new do |s|
  s.name = 'cmdr'
  s.version = '0.3.3'
  s.summary = 'cmdr'
    s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('builder')
  s.add_dependency('rscript') 
  s.signing_key = '../privatekeys/cmdr.pem'
  s.cert_chain  = ['gem-public_cert.pem']
end
