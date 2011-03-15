class Converter

  def initialize(to_process, output_file)
    @to_process = to_process
    @output_file = output_file
  end  
  
  def process(&block)
    File.open(@output_file, "w") do |f|
    
      Dir.glob(@to_process) do |file|
        
        data = File.new(file).read
        
        writer = RDF::NTriples::Writer.new( f )
        begin
          obj = yield data, File.basename(file) 
          statements = obj.statements
          statements.each do |stmt|
            writer << stmt
          end
        rescue StandardError => e
          puts "Failed to convert #{file}"
          puts e
          puts e.backtrace
        end
        
      end
    
    end    
  end
end