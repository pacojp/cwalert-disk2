MRuby::Gem::Specification.new('cwalert-disk2') do |spec|
  spec.license = 'MIT'
  spec.author  = 'paco'
  spec.summary = 'cwalert-disk2'
  spec.bins    = ['cwalert-disk2']

  spec.add_dependency 'mruby-print', :core => 'mruby-print'
  spec.add_dependency 'mruby-mtest', :mgem => 'mruby-mtest'
end
