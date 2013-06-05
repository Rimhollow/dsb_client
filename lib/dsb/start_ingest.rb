module Dsb
  class StartIngest
    include Dsb::Daemon

    def initialize options
      @client = options[:client]
      @type = "Start Ingest"
    end

    def perform_task
      if system(@client.submit_command,
                "--package #{@package.get(:ingest_path)}",
                "--username #{@client.submit_username}",
                "--password #{@client.submit_password}")
        @task.complete!
      else
        @task.fail!
      end
    end
  end
end
