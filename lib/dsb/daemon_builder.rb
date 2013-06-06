module Dsb
  class DaemonBuilder
    attr_reader :lib_path

    def initialize options
      @fields = {}
      @fields[:type] = options[:type] || 'Demonstrate DAITSS daemon builder'
      @fields[:script] = @fields[:type].downcase.gsub(/\s+/, '_')
      @fields[:klass] = @fields[:script].split(/_/).collect { |piece|
        piece.capitalize
      }.join
      @fields[:repo] = File.absolute_path('../../..', __FILE__)
      @template_dir = File.join(@fields[:repo], 'templates')
      @lib_path = File.join('dsb', @fields[:script])
    end

    def script_file
      File.join(@fields[:repo], 'scripts', @fields[:script])
    end

    def driver_file
      File.join(@fields[:repo], 'bin', @fields[:script])
    end

    def klass_file
      File.join(@fields[:repo], 'lib', 'dsb', "#{@fields[:script]}.rb")
    end

    def script
      Mustache.render(
        IO.read(File.join(@template_dir, 'script')),
        @fields
      )
    end

    def driver
      Mustache.render(
        IO.read(File.join(@template_dir, 'driver')),
        @fields
      )
    end

    def klass
      Mustache.render(
        IO.read(File.join(@template_dir, 'klass')),
        @fields
      )
    end
  end
end
