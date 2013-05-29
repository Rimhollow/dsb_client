module Dsb
  class Task
    def initialize options
      @client = options[:client]
      @data = JSON.parse(options[:json], :symbolize_names => true)
      @resource = "/tasks/#{@data[:id]}"
    end

    def complete!
      status = 'completed'
    end

    def fail!
      status = 'failed'
    end

    def status= name
      @client.submit_request :resource => @resource,
                             :body => {:name => name}
    end
  end
end
