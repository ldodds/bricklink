require 'rubygems'
require 'rest-client'
require 'libxml'

def mkdirs()
  if !File.exists?("#{ARGV[0]}")
      Dir.mkdir("#{ARGV[0]}")
  end
end

def post(opts)
  RestClient.post "http://www.bricklink.com/catalogDownload.asp", opts do |response, request, result|
    return response
  end
end

mkdirs()

parser = LibXML::XML::Parser.string( File.new(ARGV[1]).read )
doc = parser.parse

count = 0
doc.root.find("ITEM").each do |item|
  tag = item.find_first("ITEMID")
  id = tag.first.content.chomp
  opts = {
    "itemType" => "S",
    "viewType" => "4",
    "itemTypeInv" => "S",
    "itemNo" => id,
    "downloadType" => "X"
  }
  begin
    response = post(opts)
    File.open("#{ARGV[0]}/#{id}.txt", "w") do |f|
      f.puts response
    end
    puts "Cached #{id}"
    count = count + 1    
  rescue => e
    puts "Failed to fetch #{id}"
    puts e
    puts e.backtrace
  end
  
end
