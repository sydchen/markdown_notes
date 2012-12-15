require 'yaml'
require 'fileutils'
require 'rb-fsevent'
require 'logger'

module NotesWatcher
  PID_FILE = 'tmp/watcher.pid'
  FS_EVENT_WATCHER_PID_FILE =  'tmp/rb-fsevent.pid'
  MARKDOWN_RE = /\.(md|markdown|txt)$/

  extend self

  def start
    begin_time = Time.now
    script_dir = File.expand_path('../../script', __FILE__)
    config_dir = File.expand_path('../config', script_dir)
    markdown_dirs = YAML.load_file(File.join(config_dir, 'nvalt.yml'))['markdown_dir']
    logger = Logger.new('log/watch_notes.log', 'weekly')

    write_pid(PID_FILE, Process.pid)

    # start watcher
    fsevent = FSEvent.new
    options = ['--latency', 1.0.to_s, '--no-defer']
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

    #Process.daemon
    fsevent.run {|pid| 
      write_pid(FS_EVENT_WATCHER_PID_FILE, pid)
    }
  end

  def write_pid(pid_file, pid)
    if File.exist? pid_file
      if process_still_running?
        raise "Pidfile already exists at #{pid_file} and process is still running."
      else
        File.delete pid_file
      end
    else
      FileUtils.mkdir_p File.dirname(pid_file)
    end

    File.open pid_file, "w" do |f|
      f.write pid
    end
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
