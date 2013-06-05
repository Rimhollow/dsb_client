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
      ingest_path = File.join(@client.ingest_directory,
                              @package.get(:identifier))
      @package.set(:processing_path, processing_path)
      @package.set(:ingest_path, ingest_path)
      @package.save
      if (@package.get(:processing_path) == processing_path) and
         (@package.get(:ingest_path) == ingest_path)
        @task.complete!
      else
        @task.fail!
      end
    end
  end
end
