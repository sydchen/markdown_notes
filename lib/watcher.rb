#!/usr/bin/env ruby
require 'yaml'
require 'fileutils'
require 'rb-fsevent'
require 'logger'

module NotesWatcher
  PID_FILE = 'tmp/watcher.pid'
  MARKDOWN_RE = /\.(md|markdown|txt)$/

  extend self

  def start
    script_dir = File.dirname(File.expand_path(__FILE__))
    config_dir = File.expand_path('../config', script_dir)
    markdown_dirs = YAML.load_file(File.join(config_dir, 'nvalt.yml'))['markdown_dir']
    options = ['--latency', 1.0.to_s, '--no-defer']

    pid = Process.pid
    if File.exist? PID_FILE
      if process_still_running?
        raise "Pidfile already exists at #{PID_FILE} and process is still running."
      else
        File.delete PID_FILE
      end
    else
      FileUtils.mkdir_p File.dirname(PID_FILE)
    end
    File.open PID_FILE, "w" do |f|
      f.write pid
    end

    logger = Logger.new('log/watch_notes.log', 'weekly')
    begin_time = Time.now
    fsevent = FSEvent.new
    fsevent.watch markdown_dirs, options do |directories|
      directories.each do |directory|
        Dir.entries(directory).grep(MARKDOWN_RE).each do |file|
          file_name = File.join(directory, file)
          if File.stat(file_name).mtime > begin_time
            system("ruby #{script_dir}/update_notes.rb '#{file_name}'")
            logger.info "Detected changed: #{file_name}"
          end
        end
      end 
      begin_time = Time.now
    end

    Process.daemon
    fsevent.run
  end

  def process_still_running?
    old_pid = open(PID_FILE).read.strip.to_i
    Process.kill 0, old_pid
    true
  rescue Errno::ESRCH
    false
  rescue Errno::EPERM
    true
  rescue ::Exception => e
    $stderr.puts "While checking if PID #{old_pid} is running, unexpected #{e.class}: #{e}"
    true
  end

  def stop

  end
end
