GEM_ROOT = File.expand_path('../../', __FILE__)
$LOAD_PATH.unshift File.join(GEM_ROOT, 'lib')

require 'simplecov'
SimpleCov.start

require 'ognivo'
