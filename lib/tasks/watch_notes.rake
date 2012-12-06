require 'watcher'

namespace :watcher do
  desc "start notes watcher"
  task :start do
    NotesWatcher.start
  end

  desc "stop notes watcher"
  task :stop do
    NotesWatcher.stop
  end
end  
