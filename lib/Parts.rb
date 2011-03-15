require 'Util'
require 'Base'
require 'Parts'

class Parts < Collection
  
  def initialize(data)
    super(data)
    generate_statements() do |item|
      Part.new(item)      
    end
  end
    
end

class Part < LegoItemBase
    
  FIELDS = [
    "ITEMTYPE",
    "ITEMID",
    "ITEMNAME",
    "CATEGORY",
    "ITEMWEIGHT",
    "ITEMDIMX",
    "ITEMDIMY",
    "ITEMDIMZ"
  ]
  
  attr_reader :fields
  
  def initialize(tag)
    super(tag)    
    @fields = {}
    FIELDS.each do |field|
      @fields[field] = read_tag(field)
    end
    @uri = RDF::URI.new( Util.canonicalize("/part/#{@fields["ITEMID"]}"))
    generate_statements()
  end
  
  def generate_statements()
    bricklink = RDF::Vocabulary.new("http://data.kasabi.com/dataset/bricklink/schema/")
    add_property( RDF.type, bricklink.Part )
    add_property( RDF::RDFS.label, RDF::Literal.new( @fields["ITEMNAME"] ) )
    add_property( RDF::DC.identifier, RDF::Literal.new( @fields["ITEMID"] ) )
      
    add_property( bricklink.category, RDF::URI.new( Util.canonicalize("/category/#{@fields["CATEGORY"]}" ) ) )
    add_property( RDF::FOAF.isPrimaryTopicOf, RDF::URI.new( "http://www.bricklink.com/catalogItem.asp?P=#{@fields["ITEMID"]}" ) )
    
    add_property( bricklink.weight, RDF::Literal.new( @fields["ITEMWEIGHT"] ) ) if @fields["ITEMWEIGHT"]
    add_property( bricklink.dimensionX, RDF::Literal.new( @fields["ITEMDIMX"] ) ) if @fields["ITEMDIMX"]
    add_property( bricklink.dimensionY, RDF::Literal.new( @fields["ITEMDIMY"] ) ) if @fields["ITEMDIMY"]
    add_property( bricklink.dimensionZ, RDF::Literal.new( @fields["ITEMDIMZ"] ) ) if @fields["ITEMDIMZ"]

    small_image = RDF::URI.new( small_image(@fields["ITEMID"]) )  
       
    exif = RDF::Vocabulary.new( "http://www.w3.org/2003/12/exif/ns# " )  
    add_property( RDF::FOAF.depiction, small_image )
    add_statement( small_image, RDF.type, RDF::FOAF.Image )     
    add_statement( small_image, exif.height, RDF::Literal.new(80, :datatype => RDF::XSD.int ) )
    add_statement( small_image, exif.width, RDF::Literal.new(60, :datatype => RDF::XSD.int ) )
    add_statement( small_image, RDF::RDFS.label, "Picture of Lego part #{@fields["ITEMID"]}")
    
    large_image = RDF::URI.new( large_image(@fields["ITEMID"]) )  
       
    add_property( RDF::FOAF.depiction, large_image )
    add_statement( large_image, RDF.type, RDF::FOAF.Image )     
    add_statement( large_image, RDF::RDFS.label, "Picture of Lego part #{@fields["ITEMID"]}")
            
  end

  #80 x 60  
  def small_image(id)
    return "http://img.bricklink.com/P/11/#{id}.gif"
  end

  def large_image(id)
    return "http://www.bricklink.com/PL/#{id}.gif"
  end
    
end
