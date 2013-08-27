module Dsb
  class AddDaitssMets
    include Dsb::Daemon

    def initialize options
      @client = options[:client]
      @type = "Add DAITSS METS"
    end

    def perform_task
      template_data = {
        :package_id => @package.get(:identifier),
        :package_title => @package.get(:what),
        :create_date => Time.now.utc.iso8601,
        :account => @project_info.get(:account),
        :project => @project_info.get(:project),
        :data_files => [],
        :bagit_files => [],
      }

      processing_path = File.absolute_path(@package.get(:processing_path))
      bag = BagIt::Bag.new processing_path

      IO.readlines(bag.manifest_file("md5")).each_with_index do |line, index|
        checksum, path = line.chomp.split(' ')
        file_id = "DATA#{index + 1}"
        size = File.size(File.join(processing_path, path))
        template_data[:data_files] << {
          :file_id => file_id,
          :size => size,
          :checksum => checksum,
          :path => path,
        }
      end

      Dir.foreach(processing_path).each_with_index do |path, index|
        absolute_path = File.join(processing_path, path)
        if File.file?(absolute_path)
          file_id = "BAGIT#{index + 1}"
          # absolute_path = File.join(processing_path, path)
          size = File.size(absolute_path)
          checksum = Digest::MD5.hexdigest(File.read(absolute_path))
          template_data[:bagit_files] << {
            :file_id => file_id,
            :size => size,
            :checksum => checksum,
            :path => path,
          }
        end
      end

      File.open(File.join(processing_path, @package.get(:identifier) + ".xml"), 'w') do |f|
        f.write(Mustache.render(File.read("templates/sip_descriptor.mustache"), template_data))
      end

      # TODO: Add proper error checking
      @task.complete!
    end
  end
end
