$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubygems'
require 'rdf'
require 'Converter'
require 'Instructions'

converter = Converter.new("#{ARGV[0]}/Instructions.txt", "#{ARGV[1]}/instructions.nt" )

converter.process do |data, filename|
  Instructions.new(data)
end
