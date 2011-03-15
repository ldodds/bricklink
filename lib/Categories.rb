require 'Util'
require 'Base'

class Categories < Collection

  attr_reader :lookup
    
  def initialize(data)
    super(data)
    @lookup = {}
    @root.find("ITEM").each do |item|
      @lookup[ read_tag("CATEGORYNAME", item) ] = read_tag("CATEGORY", item) 
    end    
    generate_statements() do |item|
      Category.new(item, self)      
    end

  end
  
end

class Category < Base
    
  FIELDS = [
    "CATEGORY",
    "CATEGORYNAME"
  ]
  
  def initialize(tag, categories)
    super(tag)
    @categories = categories
    FIELDS.each do |field|
      @fields[field] = read_tag(field)
    end      
    @uri = RDF::URI.new( Util.canonicalize("/category/#{@fields["CATEGORY"]}"))
    generate_statements()
  end
  
  def generate_statements()
    bricklink = RDF::Vocabulary.new("http://data.kasabi.com/dataset/bricklink/schema/")
    
    add_property( RDF.type, bricklink.Category )    
    add_property( RDF.type, RDF::SKOS.Concept )
    add_property( RDF::SKOS.prefLabel, @fields["CATEGORYNAME"] )
    add_property( RDF::SKOS.inScheme, RDF::URI.new("http://data.kasabi.com/dataset/bricklink/category") )
    add_property( RDF::DC.identifier, RDF::Literal.new( @fields["CATEGORY"] ) )
          
    name_parts = @fields["CATEGORYNAME"].split(",") 
    if name_parts.length > 1
      name_parts = name_parts[0..-2]
      parent = @categories.lookup[name_parts.join(",")]
      if parent != nil
        parent_uri = RDF::URI.new( Util.canonicalize("/category/#{parent}"))
        add_property( RDF::SKOS.broader, parent_uri)
        add_statement( parent_uri, RDF::SKOS.narrower, @uri)
      end
    end
  end
  
end