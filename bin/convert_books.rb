$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubygems'
require 'rdf'
require 'Converter'
require 'Books'

converter = Converter.new("#{ARGV[0]}/Books.txt", "#{ARGV[1]}/books.nt" )

converter.process do |data, filename|
  Books.new(data)
end
