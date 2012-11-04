# encoding: utf-8
desc "create symbolic links from nvALT"
task :symlinks do
  markdown_dir = YAML.load_file('config/nvalt.yml')['markdown_dir']
  dest_dir = File.join(Rails.root, 'source')
  FileUtils.mkdir_p(dest_dir) unless File.exist?(dest_dir)

  # remove symbolic links in dest_dir
  Dir.entries(dest_dir).each do |file_name|
    file = File.join(dest_dir, file_name)
    if FileTest.symlink? file
      File.unlink file
    end  
  end
  exit
  markdown_files = Dir.entries(markdown_dir).grep(/\.txt/)
  markdown_files.each do |file_name|
    puts "#{File.join(markdown_dir, file_name)} to #{File.join(dest_dir, file_name)}"
    File.symlink(File.join(markdown_dir, file_name), File.join(dest_dir, file_name)) 
  end
end  
