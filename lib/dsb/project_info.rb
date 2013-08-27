module Dsb
  class ProjectInfo
    attr_reader :data

    def initialize options
      @client = options[:client]
      @data = options[:data]
      @resource = "/project_infos/#{@data[:id]}"
    end

    def get(field)
      if @data.keys.include? field
        @data[field]
      end
    end
  end
end
