module Dsb
  class Daemon
    attr_reader :package, :task

    def initialize options
      @client = options[:client]
      @type = options[:type]
    end

    # The perform_task method may freely access
    # the following objects:
    #
    #   @package - a member of Dsb::Package
    #   @task - a member of Dsb::Task
    #
    # The perform_task method is responsible
    # for calling one of the following methods
    # before exiting:
    #
    #   @task.complete! 
    #   @task.fail!
    #
    def perform_task
      # actually do the work
    end

    def run
      # maybe put this in a loop
      perform_task if claim_task
    end

    def claim_task
      json = @client.submit_request :resource => '/tasks/claim',
                                    :body => {:type => @type}
      if json[:package] and json[:task]
        @package = Package.new :json => json[:package], 
                               :client => @client
        @task = Task.new :json => json[:task], 
                         :client => @client
      else
        nil
      end
    end
  end
end
