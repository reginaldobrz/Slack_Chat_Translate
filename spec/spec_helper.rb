require 'simplecov'
require 'rspec'

SimpleCov.start do
  enable_coverage :branch
end

$LOAD_PATH.unshift File.expand_path("../../app/services", __FILE__)
$LOAD_PATH.unshift File.expand_path("../../app/controllers", __FILE__)

