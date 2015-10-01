# coding: utf-8
lib = File.expand_path('../lib/**', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

VERSION = "0.3.6"

Gem::Specification.new do |spec|
  spec.name          = "swiss_db"
  spec.version       = VERSION
  spec.authors       = ["Jonathan Silverman"]
  spec.email         = ["jsilverman2@gmail.com"]

  spec.summary       = %q{Android ActiveRecord ORM for RubyMotion}
  spec.description   = %q{Emulates ActiveRecord for SQLite Android}
  spec.homepage      = "http://github.com/jsilverMDX"
  spec.license       = "MIT"


  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/**'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
