$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubygems'
require 'rdf'
require 'Converter'
require 'Products'

converter = Converter.new("#{ARGV[0]}/Gear.txt", "#{ARGV[1]}/products.nt" )

converter.process do |data, filename|
  Products.new(data)
end
