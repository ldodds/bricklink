$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubygems'
require 'rdf'
require 'Converter'
require 'Minifigs'

converter = Converter.new("#{ARGV[0]}/Minifigs.txt", "#{ARGV[1]}/minifigs.nt" )

converter.process do |data, filename|
  Minifigs.new(data)
end
