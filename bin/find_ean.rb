require 'rubygems'
require 'kasabi'
require 'cgi'
require 'open-uri'
require 'linkeddata'

bricklink = RDF::Vocabulary.new("http://data.kasabi.com/dataset/bricklink/schema/")

graph = RDF::Graph.load(ARGV[0])
rdf_query = RDF::Query.new( {
  :set => {
    RDF.type => bricklink.Set,
    RDF::DC.identifier => :id
  }
})

rdf_query.execute(graph).each do |solution|  
  set = solution.set.to_s
  id = solution.id.to_s
  
  begin
    
    id = id.split("-")[0]
    uri = "https://www.briksets.nl/api/?set=#{id}&get=ean"
    ean = open(uri).read
    
    if ean != nil && ean != ""
      puts "<#{set}> <http://purl.org/goodrelations/v1#hasEAN_UCC-13> \"#{ean}\"."
    else
      puts "# No match for #{id}"
    end
  
  rescue HTTPClient::ReceiveTimeoutError => e  
     puts "# Timeout for #{id}"      
  rescue => x
     puts "# x for #{id} "
     #puts x.backtrace 
  end 
  
end
