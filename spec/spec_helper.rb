$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require_relative '../lib/qaa/helpers'
require_relative '../lib/qaa/api_handler'
require 'simplecov'
require 'simplecov-teamcity-summary/formatter'

PROJECT_DIRECTORY = File.expand_path(File.dirname(__FILE__) + "/build" )

SimpleCov.start do
  at_exit do
    SimpleCov::Formatter::TeamcitySummaryFormatter.new.format(SimpleCov.result) if ENV['TEAMCITY_VERSION']
  end
end