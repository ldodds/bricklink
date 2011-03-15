require 'libxml'
require 'Util'

#Base class for item collections, captured as XML
class Collection
  attr_reader :statements
  
  def initialize(data)
    super()
    parser = LibXML::XML::Parser.string(data)
    doc = parser.parse
    @statements = []
    @root = doc.root
  end
  
  def generate_statements(&block)  
    @root.find("ITEM").each do |item|
      part = yield item
      part.statements.each do |stmt|
        @statements << stmt
      end      
    end       
  end

  def read_tag(tagname, base=@root)
    tag = base.find_first(tagname)
    if tag != nil && tag.first && tag.first.content != nil
        return tag.first.content
    end
    return nil    
  end
  
end

class Base
  
  attr_reader :statements

  def initialize(tag)
    @root = tag
    @statements = []
    @fields = {}
  end
  
  def add_property(predicate, object)
    add_statement( @uri, predicate, object )
  end
   
  def add_statement(subject, predicate, object)
    @statements << RDF::Statement.new( subject, predicate, object )
  end
  
  def read_tag(tagname, base=@root)
    tag = base.find_first(tagname)
    if tag != nil && tag.first && tag.first.content != nil
        return tag.first.content
    end
    return nil    
  end
  
end

#Base class for individual catalog items
class LegoItemBase < Base
  
  COMMON_FIELDS = [
    "ITEMTYPE",
    "ITEMID",
    "ITEMNAME",
    "CATEGORY",
  ]
  
  def initialize(tag)
    super(tag)
    COMMON_FIELDS.each do |field|
      @fields[field] = read_tag(field)
    end            
  end
    
end
