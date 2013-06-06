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
        FileUtils.rmdir File.dirname(processing_path)
        @task.complete!
      rescue e
        @task.fail!
      end
    end
  end
end
