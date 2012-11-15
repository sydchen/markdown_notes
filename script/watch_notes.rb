# encoding: utf-8
require 'yaml'
require 'fileutils'
require 'rb-fsevent'

script_dir = File.dirname(File.expand_path(__FILE__))
markdown_dirs = YAML.load_file('config/nvalt.yml')['markdown_dir']
options = ['--latency', 1.0.to_s, '--no-defer']

MARKDOWN_RE = /\.(md|markdown|txt)$/

begin_time = Time.now
fsevent = FSEvent.new
fsevent.watch markdown_dirs, options do |directories|
  directories.each do |directory|
    Dir.entries(directory).grep(MARKDOWN_RE).each do |file|
      file_name = File.join(directory, file)
      if File.stat(file_name).mtime > begin_time
        ret = system("ruby #{script_dir}/update_notes.rb '#{file_name}'")
        puts "Detected changed: #{file_name} #{ret}"
      end
    end
  end 
  begin_time = Time.now
end

fsevent.run


