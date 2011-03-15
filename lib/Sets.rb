require 'Util'
require 'Base'
require 'Parts'

class Sets < Collection
  
  def initialize(data)
    super(data)
    generate_statements() do |item|
      Set.new(item)      
    end
  end
  
end

class Set < LegoItemBase
  
  FIELDS = [
    "ITEMYEAR",
    "ITEMWEIGHT",
    "ITEMDIMX",
    "ITEMDIMY",
    "ITEMDIMZ"
  ]
  
  def initialize(tag)
    super(tag)    
    FIELDS.each do |field|
      @fields[field] = read_tag(field)
    end
    @uri = RDF::URI.new( Util.canonicalize("/set/#{@fields["ITEMID"]}"))
    generate_statements()
  end
  
  def generate_statements()
    bricklink = RDF::Vocabulary.new("http://data.kasabi.com/dataset/bricklink/schema/")
    add_property( RDF.type, bricklink.Set )
    
    add_property( RDF::RDFS.label, RDF::Literal.new( @fields["ITEMNAME"] ) )
    add_property( RDF::DC.identifier, RDF::Literal.new( @fields["ITEMID"] ) )
            
    add_property( bricklink.category, RDF::URI.new( Util.canonicalize("/category/#{@fields["CATEGORY"]}" ) ) )    
    add_property( RDF::DC.published, RDF::Literal.new( @fields["ITEMYEAR"]) ) if @fields["ITEMYEAR"]
      
    add_property( RDF::FOAF.isPrimaryTopicOf, RDF::URI.new( "http://www.bricklink.com/catalogItem.asp?S=#{@fields["ITEMID"]}" ) )
    add_property( RDF::FOAF.isPrimaryTopicOf, RDF::URI.new( "http://www.peeron.com/inv/sets/#{@fields["ITEMID"]}" ) )
    add_property( RDF::FOAF.isPrimaryTopicOf, RDF::URI.new( "http://www.brickset.com/detail/?Set=#{@fields["ITEMID"]}" ) )    
    add_property( RDF::FOAF.isPrimaryTopicOf, RDF::URI.new( "http://guide.lugnet.com/set/#{@fields["ITEMID"].split("-")[0]}" ) )        

#    add_property( bricklink.instructions, RDF::URI.new( "http://www.bricklink.com/catalogItem.asp?I=#{@fields["ITEMID"]}") )  
      
    add_property( bricklink.weight, RDF::Literal.new( @fields["ITEMWEIGHT"] ) ) if @fields["ITEMWEIGHT"]
    add_property( bricklink.dimensionX, RDF::Literal.new( @fields["ITEMDIMX"] ) ) if @fields["ITEMDIMX"]
    add_property( bricklink.dimensionY, RDF::Literal.new( @fields["ITEMDIMY"] ) ) if @fields["ITEMDIMY"]
    add_property( bricklink.dimensionZ, RDF::Literal.new( @fields["ITEMDIMZ"] ) ) if @fields["ITEMDIMZ"]
      
    image = RDF::URI.new( "http://www.bricklink.com/SL/#{@fields["ITEMID"]}.jpg" )
    add_property( RDF::FOAF.depiction, image )
    add_statement( image, RDF.type, RDF::FOAF.Image )     
    add_statement( image, RDF::RDFS.label, "Picture of Lego set #{@fields["ITEMID"]}")
      
  end  
  
end