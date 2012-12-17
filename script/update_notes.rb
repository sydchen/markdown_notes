# encoding: utf-8
require File.join(File.dirname(__FILE__), '../config/environment.rb')

if ARGV.size > 0
  ARGV.each do |file|
    Note.from_file(file) if File.exists?(file)
  end
end  

