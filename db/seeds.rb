# encoding: utf-8
require 'fileutils'

MARKDOWN_RE = /\.(md|markdown|txt)$/

def generate
  markdown_dirs = YAML.load_file('config/nvalt.yml')['markdown_dir']
  markdown_dirs.each do |markdown_dir|
    markdown_files = Dir.entries(markdown_dir).grep(MARKDOWN_RE)
    markdown_files.each do |file_name|
      Note.from_file(File.join(markdown_dir, file_name), file_name)  
    end
  end  
end

#Note.delete_all
generate
