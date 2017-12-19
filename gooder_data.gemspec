lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gooder_data/version'

Gem::Specification.new do |spec|
  spec.name          = "gooder_data"
  spec.version       = GooderData::VERSION
  spec.authors       = ["guih"]
  spec.email         = ["opensource@resultadosdigitais.com.br"]
  spec.summary       = %q{GoodData API client and SSO implementation utilities}
  spec.description   = %q{Flexible and easy GoodData integration utilities for ruby}
  spec.homepage      = "https://github.com/ResultadosDigitais/gooder_data"
  spec.license       = "MIT"

  # spec.files         = `git ls-files -z`.split("\x0") # commented because of Gem::Package::TooLongFileName that was raising
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'gpgme', '~> 2.0', '>= 2.0.15'
  spec.add_dependency "httparty"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock", "1.11.0" # this version is required by the vcr
  spec.add_development_dependency "pry"
  spec.add_development_dependency "ZenTest"
  spec.add_development_dependency "autotest-fsevent"
  spec.add_development_dependency "autotest-growl"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "activesupport"
end
