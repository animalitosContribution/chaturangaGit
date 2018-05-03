Gem::Specification.new do |s|
  s.authors = ['Daniel Vera']
  s.date = '2017-05-23'
  s.email = ''
  s.homepage = ''
  s.license = 'MIT'
  s.name = 'gchlog'
  s.summary = ''
  s.version = '0.1.0'

  s.require_paths = ['lib']
  s.required_ruby_version = '>= 1.9'
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.requirements = ['git 1.6.0.0, or greater']

  s.files = [
    'lib/gchlog.rb',
    'lib/gchlog/Changelog.rb',
    'lib/gchlog/vegan/GitDirectory.rb'
  ]
end
