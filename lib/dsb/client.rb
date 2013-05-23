module Dsb
  class Client
    def initialize config 
      connection = YAML.load(IO.read config)
      @hydra = Typhoeus::Hydra.new
      @api_host = connection["default"]["api_host"]
      @api_key = connection["default"]["api_key"]
      @api_version = connection["default"]["api_version"]
    end

    def packages
      request = Typhoeus::Request.new(
        "#{@api_host}/packages",
        method: :get,
        headers: {
          Accept: "application/vnd.presence.dsb.v#{@api_version}",
          Authorization: "Token token=#{@api_key}"
        }
      )
      @hydra.queue(request)
      @hydra.run
      response = request.response
      ap JSON.parse(request.response.body)
    end
  end
end
