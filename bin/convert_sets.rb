$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubygems'
require 'rdf'
require 'Converter'
require 'Sets'

converter = Converter.new("#{ARGV[0]}/Sets.txt", "#{ARGV[1]}/sets.nt" )

converter.process do |data, filename|
  Sets.new(data)
end
