require 'Util'
require 'Base'
require 'Parts'

class Minifigs < Collection
  
  def initialize(data)
    super(data)
    generate_statements() do |item|
      Minifig.new(item)      
    end
  end
  
end

class Minifig < LegoItemBase
  
  FIELDS = [
    "ITEMWEIGHT"
  ]
  
  def initialize(tag)
    super(tag)    
    FIELDS.each do |field|
      @fields[field] = read_tag(field)
    end
    @uri = RDF::URI.new( Util.canonicalize("/minifig/#{@fields["ITEMID"]}"))
    generate_statements()
  end
  
  def generate_statements()
    bricklink = RDF::Vocabulary.new("http://data.kasabi.com/dataset/bricklink/schema/")
    add_property( RDF.type, bricklink.Minifig )
    add_property( RDF::DC.identifier, RDF::Literal.new( @fields["ITEMID"] ) )
      
    add_property( RDF::RDFS.label, RDF::Literal.new( @fields["ITEMNAME"] ) )
    add_property( bricklink.category, RDF::URI.new( Util.canonicalize("/category/#{@fields["CATEGORY"]}" ) ) )    
      
    add_property( bricklink.weight, RDF::Literal.new( @fields["ITEMWEIGHT"] ) ) if @fields["ITEMWEIGHT"]
      
  end  
end