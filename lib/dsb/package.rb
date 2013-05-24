module Dsb
  class Package
    def initialize options
      if options.keys.include? :file
        @json = IO.read(options[:file])
      end

      if options.keys.include? :type
        @type = options[:type]
      end

      @client = options[:client]
    end

    def claim
      response = @client.submit_request :method => :post, 
                                        :resource => '/tasks/claim',
                                        :body => {
                                          :type => @type,
                                        }
    end

    def save
      response = @client.submit_request :method => :post, 
                                        :resource => '/packages', 
                                        :body => {
                                          :package => @json,
                                        }
    end
  end
end
