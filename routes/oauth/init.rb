require_relative 'auth' if RUBY_VERSION >= "1.9"
require File.join(File.dirname(__FILE__), 'auth') if RUBY_VERSION < "1.9"
