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

#cache manifest
task :download => [:init] do
  #TODO
end

task :cache_inventories do
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