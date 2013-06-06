module Dsb
  class Cleanup
    include Dsb::Daemon

    def initialize options
      @client = options[:client]
      @type = "Cleanup"
    end

    def perform_task
      ingest_path = File.absolute_path(@package.get(:ingest_path))
      begin
        FileUtils.rm_rf File.dirname(ingest_path)
        @task.complete!
      rescue e
        @task.fail!
      end
    end
  end
end
