module Dsb
  class GetPath
    include Dsb::Daemon

    def initialize options
      @client = options[:client]
      @type = "Get Path"
    end

    def perform_task
      processing_path = File.join(@client.processing_directory,
                              @package.get(:identifier))
      @package.set(:processing_path, processing_path)
      @package.save
      if @package.get(:processing_path) == processing_path
        @task.complete!
      else
        @task.fail!
      end
    end
  end
end
