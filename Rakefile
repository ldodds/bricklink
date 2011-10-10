require 'rubygems'
require 'rake'
require 'rake/clean'

CACHE_DIR="data/cache"
RDF_DIR="data/nt"

CLEAN.include ["#{RDF_DIR}/*.nt", "#{RDF_DIR}/*.gz"]

#Helper function to create data dirs
def mkdirs()
  if !File.exists?("data")
    Dir.mkdir("data")
  end  
  if !File.exists?(CACHE_DIR)
    Dir.mkdir(CACHE_DIR)
  end
  if !File.exists?(RDF_DIR)
    Dir.mkdir(RDF_DIR)
  end
end

task :init do
  mkdirs()
end

task :download => [:init] do
  URL = "http://www.bricklink.com/catalogDownload.asp?a=a"
  params = "&viewType=0&&selYear=Y&selWeight=Y&selDim=Y&downloadType=X"
  sh %{curl -d "itemType=S#{params}" #{URL} >#{CACHE_DIR}/Sets.txt}
  sh %{curl -d "itemType=P#{params}" #{URL} >#{CACHE_DIR}/Parts.txt}   
  sh %{curl -d "itemType=M#{params}" #{URL} >#{CACHE_DIR}/Minifigs.txt}
  sh %{curl -d "itemType=B#{params}" #{URL} >#{CACHE_DIR}/Books.txt}
  sh %{curl -d "itemType=G#{params}" #{URL} >#{CACHE_DIR}/Gear.txt}
  sh %{curl -d "itemType=C#{params}" #{URL} >#{CACHE_DIR}/Catalogs.txt}
  sh %{curl -d "itemType=I#{params}" #{URL} >#{CACHE_DIR}/Instructions.txt}     
  sh %{curl -d "itemType=O#{params}" #{URL} >#{CACHE_DIR}/Original-Boxes.txt}
  
  sh %{curl -d "viewType=1&downloadType=X" #{URL} >#{CACHE_DIR}/itemtypes.txt}
  sh %{curl -d "viewType=2&downloadType=X" #{URL} >#{CACHE_DIR}/categories.txt}
  sh %{curl -d "viewType=3&downloadType=X" #{URL} >#{CACHE_DIR}/colors.txt}
  sh %{curl -d "viewType=5&downloadType=X" #{URL} >#{CACHE_DIR}/codes.txt}
  
  #Cache inventories
  sh %{ruby bin/cache_inventories.rb data/cache/inventory data/cache/Sets.txt}
end

task :convert_static do
  Dir.glob("etc/static/*.ttl").each do |src|
      sh %{rapper -i turtle -o ntriples #{src} >#{RDF_DIR}/#{File.basename(src, ".ttl")}.nt}
  end
end

task :convert_parts do
  sh %{ruby bin/convert_parts.rb #{CACHE_DIR} #{RDF_DIR}}
end

task :convert_books do
  sh %{ruby bin/convert_books.rb #{CACHE_DIR} #{RDF_DIR}}
end

task :convert_catalogs do
  sh %{ruby bin/convert_catalogs.rb #{CACHE_DIR} #{RDF_DIR}}
end

task :convert_categories do
  sh %{ruby bin/convert_categories.rb #{CACHE_DIR} #{RDF_DIR}}
end

task :convert_colors do
  sh %{ruby bin/convert_colors.rb #{CACHE_DIR} #{RDF_DIR}}
end

task :convert_sets do
  sh %{ruby bin/convert_sets.rb #{CACHE_DIR} #{RDF_DIR}}
end

task :convert_minifigs do
  sh %{ruby bin/convert_minifigs.rb #{CACHE_DIR} #{RDF_DIR}}
end

task :convert_products do
  sh %{ruby bin/convert_products.rb #{CACHE_DIR} #{RDF_DIR}}
end

task :convert_instructions do
  sh %{ruby bin/convert_instructions.rb #{CACHE_DIR} #{RDF_DIR}}
end

task :convert_inventories do
  sh %{ruby bin/convert_inventories.rb #{CACHE_DIR}/inventory #{RDF_DIR}}
end

task :convert => [:init, :convert_parts, :convert_books, :convert_catalogs, 
  :convert_categories, :convert_colors, :convert_sets, :convert_minifigs, 
  :convert_products, :convert_instructions, :convert_inventories]

task :find_ean do
  sh %{ruby bin/find_ean.rb #{RDF_DIR}/sets.nt >#{RDF_DIR}/ean.nt}
end

#task :reconcile_categories do
#  sh %{ruby bin/reconcile_categories.rb #{RDF_DIR}/categories.nt >#{RDF_DIR}/category-sameas.nt}
#end

task :link => [:find_ean]
  
task :package do
  sh %{gzip #{RDF_DIR}/*} 
end

task :publish => [:download, :convert, :package]