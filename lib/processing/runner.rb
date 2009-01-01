['optparse', 'ostruct'].each {|f| require f }

module Processing
  
  class Runner
    
    # Start running a ruby-processing sketch from the passed-in arguments
    def self.execute
      runner = new
      runner.parse_options(ARGV)
      runner.execute!
    end
    
    def initialize(out_stream = STDOUT, error_stream = STDERR)
      @out_stream, @error_stream = out_stream, error_stream
      @options = OpenStruct.new
      @options.action = :run, 
      @options.path = File.basename(Dir.pwd) + '.rb'
    end
    
    def parse_options(args)
      # EWGG!
    end
    
    def execute!
      case @options.action
      when :run     : run(@options.path)
      when :watch   : watch(@options.path)
      when :create  : create(@options.path)
      when :live    : live(@options.path)
      when :sample  : sample(@options.path)
    end
    
    def parse_options(args)
      begin
        args.extend(OptionParser::Arguable)
        args.options do |opts|
          opts.banner = "Usage: rp5 []"
          
          opts.separator ""
          opts.separator "Creating a fresh project:"
          
          opts.on('create', 'create [SKETCH]', 'Create a new Ruby-Processing sketch') do |sketch|
            @options.action = :create
            @options.path = sketch
          end
          
          opts.separator ""
          opts.separator "Running a project:"
          
          opts.on "run", "run [SKETCH]", 'Run a Ruby-Processing sketch' do |sketch|
            @options.action :run
            @options.path = sketch
          end
          
          opts.separator ""
          opts.separator "Extra options:"
          
          opts.on_tail('-v', '--version', 'Show version') do
            exit_with_success("ruby-processing version #{Processing.version}")
          end
          
          opts.on_tail('-h', '--help', 'Show this message') do
            exit_with_success(opts)
          end
          
        end.parse!
      rescue Exeption => e
        exit_with_error(e)
      end
    end
    
    # Create a fresh Ruby-Processing sketch, with the necessary
    # boilerplate filled out.
    def create(sketch)
      project.underscore!
      destination
    end
    
  end
  
end