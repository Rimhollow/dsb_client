module Dsb
  class GetDaitssIdentifier
    include Dsb::Daemon

    def initialize options
      @client = options[:client]
      @type = "Get DAITSS Identifier"
    end

    def perform_task
      normalizer = Normalizer.new
      identifier = normalizer.normalize(@package.get :uploader_uid)
      @package.set(:identifier, identifier)
      @package.save
      if @package.get(:identifier) == identifier
        @task.complete!
      else
        @task.fail!
      end
    end
  end
end
