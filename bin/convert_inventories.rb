$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubygems'
require 'rdf'
require 'Inventory'

File.open("#{ARGV[1]}/inventories.nt", "w") do |f|

  Dir.glob("#{ARGV[0]}/*.txt") do |file|
    
    data = File.new(file).read
    
    if !data.start_with?("<HTML>")
      writer = RDF::NTriples::Writer.new( f )
      begin
       inventory = Inventory.new( File.basename(file, ".txt"), data )
       statements = inventory.statements()
       statements.each do |stmt|
          writer << stmt
      end
      rescue StandardError => e
        puts "Failed to convert #{file}"
        puts e
        puts e.backtrace
      end
    else
      puts "Skipping #{file} containing HTML"
    end
    
  end

end