module Dsb
  class StageFiles
    include Dsb::Daemon

    def initialize options
      @client = options[:client]
      @type = "Stage Files"
    end

    def perform_task
      source_path = File.absolute_path(@package.get(:source_path))
      processing_path = File.absolute_path(@package.get(:processing_path))
      FileUtils.mkdir processing_path
      processing_directory = File.absolute_path(@client.processing_directory)
      if File.directory?(source_path) and File.directory?(processing_path)
        # XXX Repeat the following until it stabilizes
        if system(@client.rsync_command, @client.rsync_options,
                  source_path, processing_path)
          @task.complete!
        else
          @task.fail!
        end
      else
        @task.fail!
      end
    end
  end
end
