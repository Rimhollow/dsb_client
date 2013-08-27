module Dsb
  module Daemon
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
      while true
	perform_task if claim_task
        sleep 30
      end
    end

    def claim_task
      data = @client.submit_request :resource => '/tasks/claim',
                                    :body => {:type => @type}
      if data[:package] and data[:project_info] and data[:task]
        @package = Package.new :data => data[:package], 
                               :client => @client
        @project_info = ProjectInfo.new :data => data[:project_info],
                                        :client => @client
        @task = Task.new :data => data[:task], 
                         :client => @client
      else
        nil
      end
    end
  end
end
