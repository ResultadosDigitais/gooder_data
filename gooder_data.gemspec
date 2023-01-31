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

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'gpgme', '~> 2.0', '>= 2.0.15'
  spec.add_dependency "httparty"

  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "bundler", "> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr", '>= 4.0'
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "ZenTest"
  spec.add_development_dependency "autotest-fsevent"
  spec.add_development_dependency "autotest-growl"
  spec.add_development_dependency "activesupport"
end
