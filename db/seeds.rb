# encoding: utf-8
require 'fileutils'

#MARKDOWN_RE = /\.(md|markdown|txt)$/

def generate
  markdown_dirs = YAML.load_file('config/nvalt.yml')['markdown_dir']
  markdown_dirs.each do |markdown_dir|
    #markdown_files = Dir.glob(File.join(markdown_dir, '**')).grep(MARKDOWN_RE)
    markdown_files = Dir.glob(File.join(markdown_dir, '**', '*.{md,markdown,txt}'))
    markdown_files.each do |file|
      Note.from_file(file)  
    end
  end  
end

#Note.delete_all
generate
