$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubygems'
require 'rdf'
require 'Converter'
require 'Categories'

converter = Converter.new("#{ARGV[0]}/categories.txt", "#{ARGV[1]}/categories.nt" )

converter.process do |data, filename|
  Categories.new(data)
end
