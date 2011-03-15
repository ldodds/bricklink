require 'Util'
require 'Base'
require 'Parts'

class Products < Collection
  
  def initialize(data)
    super(data)
    generate_statements() do |item|
      Product.new(item)      
    end

  end
  
end

class Product < LegoItemBase
    
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
    @uri = RDF::URI.new( Util.canonicalize("/product/#{@fields["ITEMID"]}"))
    generate_statements()
  end
  
  def generate_statements()
    bricklink = RDF::Vocabulary.new("http://data.kasabi.com/dataset/bricklink/schema/")
    add_property( RDF.type, bricklink.Product )
    
    add_property( RDF::RDFS.label, RDF::Literal.new( @fields["ITEMNAME"] ) )
    add_property( RDF::DC.identifier, RDF::Literal.new( @fields["ITEMID"] ) )
            
    add_property( bricklink.category, RDF::URI.new( Util.canonicalize("/category/#{@fields["CATEGORY"]}" ) ) )    
    add_property( RDF::DC.published, RDF::Literal.new( @fields["ITEMYEAR"]) ) if @fields["ITEMYEAR"]
      
    add_property( bricklink.weight, RDF::Literal.new( @fields["ITEMWEIGHT"] ) ) if @fields["ITEMWEIGHT"]
    add_property( bricklink.dimensionX, RDF::Literal.new( @fields["ITEMDIMX"] ) ) if @fields["ITEMDIMX"]
    add_property( bricklink.dimensionY, RDF::Literal.new( @fields["ITEMDIMY"] ) ) if @fields["ITEMDIMY"]
    add_property( bricklink.dimensionZ, RDF::Literal.new( @fields["ITEMDIMZ"] ) ) if @fields["ITEMDIMZ"]
      
  end
  
end