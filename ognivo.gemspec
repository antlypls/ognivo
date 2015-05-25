lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ognivo/version'

Gem::Specification.new do |spec|
  spec.name          = 'ognivo'
  spec.version       = Ognivo::VERSION
  spec.authors       = ['Anatoliy Plastinin']
  spec.email         = ['hello@antlypls.com']
  spec.summary       = 'Ognivo'
  spec.description   = 'Ognivo is CLI tool that automates creating OS X app builds ' \
                       'and destributing updates with Sparkle over Amazon S3.'
  spec.homepage      = 'https://github.com/antlypls/ognivo'
  spec.license       = 'MIT'

  spec.files         = %w(README.md LICENSE)
  spec.files         += Dir.glob('lib/**/*.rb')
  spec.files         += Dir.glob('bin/**/*')

  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'commander'
  spec.add_dependency 'xctools'
  spec.add_dependency 'sparklecast'
  spec.add_dependency 'redcarpet'
  spec.add_dependency 'aws-sdk', '< 2.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
end
