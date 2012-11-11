# encoding: utf-8
#require '/Users/syd/Programming/rails/markdown_notes/config/environment.rb'
require File.join(File.dirname(__FILE__), '../config/environment.rb')

if ARGV.size > 0
  ARGV.each do |file|
    Note.from_file(file, file.split('/').last) if File.exists?(file)
  end
end  

