module Dsb
  class Task
    attr_reader :data

    def initialize options
      @client = options[:client]
      @data = options[:data]
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
