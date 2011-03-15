require 'Base'
require 'Util'

class Inventory < Collection

  attr_reader :id
  attr_reader :uri
  attr_reader :set_uri
    
  def initialize(id, data)
    super(data)
    @id = id #.gsub("S-", "")
    @set_uri = RDF::URI.new( Util.canonicalize("/set/#{@id}") )
    @uri = RDF::URI.new( Util.canonicalize("/set/#{@id}/inventory") )
    generate_statements() do |item|
      InventoryPart.new(self, item)      
    end    
    add_additional_statements()
  end
  
  def add_additional_statements
    bricklink = RDF::Vocabulary.new("http://data.kasabi.com/dataset/bricklink/schema/")        
    add_statement( @set_uri, bricklink.inventory, @uri )
    add_statement( @uri, RDF.type, bricklink.Inventory )
    add_statement( @uri, bricklink.set, @set_uri )
  end
  
  def add_statement(subject, predicate, object)
    @statements << RDF::Statement.new( subject, predicate, object )
  end
  
end

class InventoryPart < Base
  
  FIELDS = [
    "ITEMTYPE",
    "ITEMID",
    "QTY",
    "COLOR",
    "EXTRA",
    "ALTERNATE",
    "MATCHID",
    "COUNTERPART"
  ]

  def initialize(inventory, tag)
    super(tag)
    @inventory = inventory    
    FIELDS.each do |field|
      @fields[field] = read_tag(field)
    end
    suffix = ""
    if @fields["COLOR"] != "0"    
      suffix = @fields["COLOR"]
    end
    if @fields["EXTRA"] == "Y"    
      suffix = "#{suffix}-extra"
    end    
    @uri = RDF::URI.new( Util.canonicalize("/set/#{@inventory.id}/inventory/#{@fields["ITEMID"]}-#{suffix}"))
    generate_statements()    
  end
  
  def generate_statements()
    bricklink = RDF::Vocabulary.new("http://data.kasabi.com/dataset/bricklink/schema/")
        
    add_property( RDF.type, bricklink.InventoryItem )
    add_property( RDF::DC.isPartOf, @inventory.uri )
    add_statement( @inventory.uri, RDF::DC.hasPart, @uri )
    add_property( RDF.value, RDF::Literal.new( @fields["QTY"], :datatype=>RDF::XSD.int ) )
    add_property( RDF::FOAF.isPrimaryTopicOf, RDF::URI.new("http://www.bricklink.com/catalogItemInv.asp?S=#{@inventory.id}"))  
    case @fields["ITEMTYPE"]
    when "P"
      add_property( bricklink.item, RDF::URI.new( Util.canonicalize("/part/#{@fields["ITEMID"]}")))      
    when "M"
      add_property( bricklink.item, RDF::URI.new( Util.canonicalize("/minifig/#{@fields["ITEMID"]}")))
    when "B"
      add_property( bricklink.item, RDF::URI.new( Util.canonicalize("/book/#{@fields["ITEMID"]}")))
    when "S"
      add_property( bricklink.item, RDF::URI.new( Util.canonicalize("/set/#{@fields["ITEMID"]}")))        
    when "G"
      add_property( bricklink.item, RDF::URI.new( Util.canonicalize("/product/#{@fields["ITEMID"]}")))        
    else 
      puts "Unexpected item type: #{@fields["ITEMTYPE"]}"
    end
    
    suffix = ""
    if @fields["EXTRA"] == "Y"
      suffix = " (Extra)"
    end
    
    if @fields["COLOR"] != "0"
      add_property( bricklink.colour, RDF::URI.new( Util.canonicalize("/color/#{@fields["COLOR"]}") ) )      
      add_property( RDF::RDFS.label, "#{@fields["QTY"]} x #{@fields["ITEMID"]} in colour #{@fields["COLOR"]}#{suffix}")
    else
      add_property( RDF::RDFS.label, "#{@fields["QTY"]} x #{@fields["ITEMID"]}#{suffix}")
    end
      
  end
    
end