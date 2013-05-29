module Dsb
  class Package
    def initialize options
      @client = options[:client]
      @data = JSON.parse(options[:json], :symbolize_names => true)
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
