require 'rubygems'
require 'rest_client'

def post(opts)
  RestClient.post "http://www.bricklink.com/catalogDownload.asp", opts do |response, request, result|
    return response
  end
end

opts = {
  "itemType" => "S",
  "viewType" => "4",
  "itemTypeInv" => "S",
  "itemNo" => ARGV[0],
  "downloadType" => "X"
}

puts post(opts)