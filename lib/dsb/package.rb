module Dsb
  class Package
    attr_reader :data

    def initialize options
      @client = options[:client]
      @data = options[:data]
      @resource = "/packages/#{@data[:id]}"
      @changed = false
    end

    def set(field, value)
      if @data.keys.include? field and @data[field] != value
        @data[field] = value
        @changed = true
      end
    end

    def save
      @client.submit_request :resource => @resource,
                             :body => @data.to_json
    end
  end
end
