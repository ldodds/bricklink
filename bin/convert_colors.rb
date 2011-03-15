$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubygems'
require 'rdf'
require 'Converter'
require 'Colors'

converter = Converter.new("#{ARGV[0]}/colors.txt", "#{ARGV[1]}/colors.nt" )

converter.process do |data, filename|
  Colors.new(data)
end
