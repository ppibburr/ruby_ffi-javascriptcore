require 'simplecov'
require 'minitest/spec'
require 'minitest/autorun'
SimpleCov.start do
  add_filter "/test/"
end
require "JS/base"
