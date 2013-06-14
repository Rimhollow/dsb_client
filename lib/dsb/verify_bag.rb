module Dsb
  class VerifyBag 
    include Dsb::Daemon

    def initialize options
      @client = options[:client]
      @type = "Verify Bag"
    end

    def perform_task
      processing_path = File.absolute_path(@package.get(:processing_path))
      bag = BagIt::Bag.new processing_path
      if bag.valid?
        @task.complete!
      else
        @task.fail!
      end
    end
  end
end
