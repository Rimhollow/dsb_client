module Dsb
  class ProjectInfo
    attr_reader :data

    def initialize options
      @client = options[:client]
      @data = options[:data]
      @resource = "/project_infos/#{@data[:id]}"
    end
  end
end
