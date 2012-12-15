require 'watcher'

namespace :watcher do
  desc "start notes watcher"
  Rake::Task['sunspot:solr:start'].invoke unless File.exist? "log/sunspot-solr-development.log.lck"
  task :start do
    NotesWatcher.start
  end

  desc "stop notes watcher"
  task :stop do
    NotesWatcher.stop
  end
end  
