module Dsb
  class ExportPackage
    include Dsb::Daemon

    def initialize options
      @client = options[:client]
      @type = "Export Package"
    end

    def perform_task
      processing_path = File.absolute_path(@package.get(:processing_path))
      ingest_path = File.absolute_path(@package.get(:ingest_path))
      begin
        FileUtils.mkdir_p File.dirname(ingest_path)
        FileUtils.move(processing_path, ingest_path)
        # We don't delete processing_path itself because if the above
        # move command was successful, it no longer exists.
        FileUtils.rmdir File.dirname(processing_path)
        @task.complete!
      rescue e
        @task.fail!
      end
    end
  end
end
