module Dsb
  class Package
    def initialize options
      if options.keys.include? :file
        @json = IO.read(options[:file])
      end

      @client = options[:client]
    end

    def save
      response = @client.submit_request :method => :post, 
                                        :resource => '/packages', 
                                        :body => {
                                          :package => @json,
                                        }
      ap response
    end
  end
end
