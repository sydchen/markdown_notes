## Setup Vagrant VM for Reporting Service
### Required files
* <code>Vagrantfile</code>
* <code>Cheffile</code>
* <code>.chloe/setup.rb</code>

```
module ReportingService
  module CLI
    class Setup < Chloe::Task
      summary 'Sets up the VM with all dependencies'

      default_task :setup

      desc :setup, 'Sets up the VM'
      def setup
        exec 'bash', './.chloe/executables/setup'
      end
    end
  end
end
```

*ReportingService* 是rails app module name, 請參考<code>config/application.rb</code>

```
module ReportingService
class Application < Rails::Application
```

* <code>.chloe/executables/setup</code>
    * APP_NAME: rails app module name
    * IP_ADDRESS: 同Vagrantfile中的設定

```bash
#! /bin/sh

APP_NAME="ReportingService"
IP_ADDRESS="reporting.dev"

function main {
  echo "=== $APP_NAME"
  preflight_checklist
  cookbooks_bootstrap
  vagrant_bootstrap
  echo "=== $APP_NAME is booted and running at $IP_ADDRESS"
}

function preflight_checklist {
  echo "=== Running Pre-flight Checklist"
  confirm_virtualbox
  confirm_bundler
  bundle_gems
}

function confirm_virtualbox {
  flight_check_command "virtualbox" "Virtual Box"
}

function confirm_bundler {
  flight_check_gem "bundler" "Bundler"
}

function flight_check_command {
  if command -v $1 >/dev/null 2>&1; then
    echo "    ✓ $2 Installed"
  else
    echo "    ✗ $2 Not Installed, please make sure that it is installed before continuing"
    exit 1;
  fi
}

function flight_check_gem {
  if gem which $1 >/dev/null 2>&1; then
    echo "    ✓ $2 Installed"
  else
    echo "    ✗ $2 Not Installed, please make sure that it is installed before continuing"
    exit 1;
  fi
}

function bundle_gems {
  if bundle check --gemfile=vm/Gemfile > /dev/null 2>&1; then
    echo "    ✓ The Gemfile's dependencies are satisfied"
  else
    echo "    ✗ The Gemfile's dependencies could not be satisfied, bundling..."
    bundle install --gemfile=vm/Gemfile || { exit 1; }
    echo "=== Resuming Preflight Checklist"
  fi
  rbenv_rehash
}

function rbenv_rehash {
  if command -v rbenv >/dev/null 2>&1; then
    rbenv rehash
  fi
}

function cookbooks_bootstrap {
  echo "    ✓ Librarian is installing cookbooks"
  librarian-chef update --verbose | grep Installing
}

function vagrant_bootstrap {
  local vagrant_status=`vagrant status | grep default | awk '{ print $2$3 }'`
  case  $vagrant_status  in
    "poweroff" | "poweredoff")
      echo "    ✗ $APP_NAME VM is powered off, booting the VM now..."
      vagrant up
      ;;
    "notcreated")
      echo "    ✗ $APP_NAME VM does not exist, bootstrapping now..."
      vagrant up
      ;;
    "aborted")
      echo "    ✗ $APP_NAME VM was not safely stopped, rebooting now..."
      vagrant up
      ;;
    "running")
      echo "    ✓ $APP_NAME VM is already running at $IP_ADDRESS..."
      ;;
  esac
}

main
```

* <code>vm/Gemfile</code>
    * 安裝vagrant vm 所需的gems

```
source 'http://rubygems.org'

gem 'vagrant'
gem 'librarian'
gem 'vagrant-dns'
```        

* 任意的執行檔, ex: reporting

```
#!/usr/bin/env ruby

require 'rubygems'
require 'chloe'

Chloe.bootstrap('ReportingService')
```       
 
