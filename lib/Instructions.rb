require 'Util'
require 'Base'

class Instructions < Collection
  
  def initialize(data)
    super(data)
    generate_statements() do |item|
      InstructionItem.new(item)      
    end

  end
  
end

class InstructionItem < LegoItemBase
    
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
    add_property( RDF.type, bricklink.Instructions )
    add_property( bricklink.instructions, RDF::URI.new( "http://www.bricklink.com/catalogItem.asp?I=#{@fields["ITEMID"]}") )
    image = RDF::URI.new( "http://www.bricklink.com/IL/#{@fields["ITEMID"]}.jpg" )
    add_property( RDF::FOAF.depiction, image )
    add_property( RDF::DC.publisher, RDF::URI.new( "http://dbpedia.org/resource/Lego_Group" ) )
        
    add_statement( image, RDF.type, RDF::FOAF.Image )     
    add_statement( image, RDF::RDFS.label, "Photo of instructions for Lego set #{@fields["ITEMID"]}")
    
  end
  
end