$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubygems'
require 'rdf'
require 'Converter'
require 'Parts'

converter = Converter.new("#{ARGV[0]}/Parts.txt", "#{ARGV[1]}/parts.nt" )

converter.process do |data, filename|
  Parts.new(data)
end
