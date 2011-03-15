require 'rubygems'
require 'kasabi'

require 'json'
require 'cgi'
require 'open-uri'
require 'linkeddata'
require 'rdf/raptor'

graph = RDF::Graph.load(ARGV[0])
rdf_query = RDF::Query.new( {
  :category => {
    RDF.type => RDF::SKOS.Concept,
    RDF::SKOS.prefLabel => :label
  }
})

reconciler = Kasabi::Reconcile::Client.new("http://ldodds.com/gridworks/dbpedia/reconcile" )

rdf_query.execute(graph).each do |solution|  
  uri = solution.category.to_s
  name = solution.label.to_s

  query = Kasabi::Reconcile::Client.make_query("#{name}", 3, :any, nil, nil)
  
  begin
    
    results = reconciler.reconcile(query)
      
#    puts results.inspect
    if results != nil && results.length > 0 && results[0]["match"] == true
      puts "<#{uri}> <http://www.w3.org/2002/07/owl#sameAs> <#{results[0]["id"]}>."
    else
      puts "# No match for #{uri}"
    end
  
  rescue HTTPClient::ReceiveTimeoutError => e  
      puts "# Timeout for #{uri}"
      
  rescue => x
     puts x
     puts x.backtrace 
  end 
  
end
