Gem::Specification.new do |s|
  s.name        = 'sunxi_gpio'
  s.version     = '0.0.4'
  s.license     = 'GNU General Public License v3'
  s.date        = '2014-09-24'
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Native Ruby Extension to work with Sunxi GPIO + SERVER"
  s.authors     = ["phortx/happychriss"]
  s.email       = 'pmsfriend@gmail.com'
  s.homepage    = 'https://github.com/happychriss/sunxi-gpio-gem.git'
  s.description = s.summary

  s.files = Dir.glob('lib/**/**/*.rb') + Dir.glob('ext/**/**/*.{c,h,rb}')
  s.extensions << 'ext/sunxi_gpio/extconf.rb'
  s.extra_rdoc_files = ['README.md']
  s.require_paths = ['lib', 'ext']

  s.required_ruby_version = '>= 1.9.3'

  s.add_development_dependency 'rake', '~> 10.1'
  s.add_development_dependency 'rake-compiler', '~> 0.9'
end
