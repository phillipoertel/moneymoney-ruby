# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moneymoney-ruby/version'

Gem::Specification.new do |gem|
  gem.name          = "moneymoney-ruby"
  gem.version       = MoneyMoney::VERSION
  gem.authors       = ["Phillip Oertel"]
  gem.email         = ["me@phillipoertel.com"]
  gem.description   = %q{moneymoney is Ruby wrapper for Outbank CSV files.}
  gem.summary       = %q{moneymoney reads a CSV file exported from MoneyMoney/MAC and converts the types to Ruby, as well as doing some cleanups.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency('rake')
  gem.add_dependency('turn')
end
