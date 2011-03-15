require 'Util'
require 'Base'

class Colors < Collection

  attr_reader :lookup
    
  def initialize(data)
    super(data)
    @lookup = {}
    generate_statements() do |item|
      Color.new(item)      
    end

  end
  
end

class Color < Base
    
  FIELDS = [
    "COLOR",
    "COLORNAME",
    "COLORRGB",
    "COLORTYPE",
    "COLORCNTPARTS",
    "COLORCNTSETS",
    "COLORCNTWANTED",
    "COLORCNTINV",
    "COLORYEARFROM",
    "COLORYEARTO"
  ]
  
  def initialize(tag)
    super(tag)
    FIELDS.each do |field|
      @fields[field] = read_tag(field)
    end      
    @uri = RDF::URI.new( Util.canonicalize("/colour/#{@fields["COLOR"]}"))
    generate_statements()
  end
  
  def generate_statements()
    bricklink = RDF::Vocabulary.new("http://data.kasabi.com/dataset/bricklink/schema/")
    
    add_property( RDF.type, bricklink.Colour )    
    add_property( RDF::RDFS.label, RDF::Literal.new(@fields["COLORNAME"] ) )
    add_property( bricklink.rgb, RDF::Literal.new(@fields["COLORRGB"])) if @fields["COLORRGB"]
    add_property( bricklink.colourType, 
      RDF::Literal.new(@fields["COLORTYPE"]) ) if (@fields["COLORTYPE"] && @fields["COLORTYPE"] != "N/A")
    add_property( RDF::DC.identifier, RDF::Literal.new( @fields["COLOR"] ) )
      
    if @fields["COLORYEARFROM"]
      add_property( bricklink.yearIntroduced, RDF::Literal.new( @fields["COLORYEARFROM"], :datatype => RDF::XSD.year ) )
    end
    if @fields["COLORYEARTO"]
      if @fields["COLORYEARTO"] != Time.new.strftime("%Y")
        add_property( bricklink.yearEnded, RDF::Literal.new( @fields["COLORYEARFROM"], :datatype => RDF::XSD.year ) )
      end
    end
    
  end
  
end