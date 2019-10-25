lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qaa/helpers/version'

Gem::Specification.new do |spec|
  spec.name = 'qaa-helpers'
  spec.version = Qaa::Helpers::VERSION
  spec.authors = ['khoahong']
  spec.email = ['hongakhoa@gmail.com']
  spec.description = 'Small functions to use as toolbox'
  spec.summary = %q{Qaa helpers.}
  spec.homepage = 'http://strongin.qa'
  spec.license = 'Nonstandard'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://geminabox.lzd.co'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  ignores = File.readlines('.gitignore').grep(/\S+/).map(&:chomp)
  dot_files = %w[.gitignore]

  all_files_without_ignores = Dir['**/*'].reject {|f|
    File.directory?(f) || ignores.any? {|i| File.fnmatch(i, f)}
  }

  spec.files = (all_files_without_ignores + dot_files).sort
  spec.add_development_dependency 'allure-cucumber'
  spec.add_development_dependency 'allure-rspec'
  spec.add_runtime_dependency 'bundler'
  spec.add_development_dependency 'qaa-fixtures'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov-teamcity-summary'
end
