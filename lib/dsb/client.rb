module Dsb
  class Client
    def initialize config 
      connection = YAML.load(IO.read config)
      @api_host = connection["default"]["api_host"]
      @api_key = connection["default"]["api_key"]
      @api_version = connection["default"]["api_version"]
      @default_headers = {
        'Accept' => "application/vnd.presence.dsb.v#{@api_version}",
        'Authorization' => "Token token=#{@api_key}",
      }
    end

    def submit_request options
      resource = options[:resource] || ''
      method = options[:method] || :post
      headers = options[:headers] || {}
      body = options[:body] || {}

      uri = URI("#{@api_host}#{resource}")

      case method
      when :post
        request = Net::HTTP::Post.new(uri.path)
        @default_headers.merge(headers).each do |h, v|
          request[h] = v
        end
        request.set_form_data(body)
      when :put
        request = Net::HTTP::Put.new(uri.path)
        @default_headers.merge(headers).each do |h, v|
          request[h] = v
        end
        request.set_form_data(body)
      end

      response = Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.request(request)
      }
      JSON.parse(response.body, :symbolize_names => true)
    end
  end
end
