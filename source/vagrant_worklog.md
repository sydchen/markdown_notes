### Create a new CentOS VM
* add a new vagrant box

```
$ vagrant box add optimis_pt http://dl.dropbox.com/u/101516065/centos.box
```
or 使用預先下載存在硬碟的vagrant box

```
$ vagrant box add optimis_pt ~/optimis/vagrant/vboxs/centos.box
```

### Create rails project to manage the VM

```
$ cd ~/vagrant
$ rails new optimis_pt
```

vagrant init

```
$ cd optimis_pt
$ vagrant init
```

產生<code>Vagrantfile</code>, 修改

```
Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "optimis_pt"
end
```

啟動

```
$ vagrant up
```

登入

```
$vagrant ssh
```

### Install required packages 
利用Chef Solo快速佈署起環境, 產生Cheffile, 設定我們需要的cookbooks, 可透過librarian-chef幫我們產生產生Cheffile

```
$ librarian-chef init
```

直接用optimis project先設好的Cheffile

```
$ cd ~/vagrant/optimis_pt
$ vim Cheffile
```

Cheffile

```
#!/usr/bin/env ruby
#^syntax detection

site 'http://community.opscode.com/api/v1'

cookbook 'yum'
cookbook 'nokogiri_dependencies', :git => 'git@github.com:optimis/vagrant-chef.git', :path => 'shared/nokogiri_dependencies'
cookbook 'curl',                  :git => 'git@github.com:optimis/vagrant-chef.git', :path => 'shared/curl'
cookbook 'imagemagick',           :git => 'git@github.com:optimis/vagrant-chef.git', :path => 'shared/imagemagick'
cookbook 'ssh-keys',              :git => 'git@github.com:optimis/vagrant-chef.git', :path => 'shared/ssh-keys'
cookbook 'git'
cookbook 'ruby_build'
cookbook 'mysql'
cookbook 'rbenv',           :git => 'git://github.com/fnichol/chef-rbenv.git'
cookbook 'prep_rbenv',      :git => 'git@github.com:optimis/vagrant-chef.git', :path => 'shared/prep_rbenv'
cookbook 'sshunnel',        :git => 'git@github.com:optimis/vagrant-chef.git', :path => 'shared/sshunnel'
cookbook 'bundle',          :git => 'git@github.com:optimis/vagrant-chef.git', :path => 'shared/bundle'
cookbook 'httpd',           :git => 'git@github.com:optimis/vagrant-chef.git', :path => 'shared/httpd'
cookbook 'passenger',       :git => 'git@github.com:optimis/vagrant-chef.git', :path => 'shared/passenger'
cookbook 'passenger_rails', :git => 'git@github.com:optimis/vagrant-chef.git', :path => 'shared/passenger_rails'
cookbook 'qt',              :git => 'git@github.com:optimis/vagrant-chef.git', :path => 'shared/qt'
cookbook 'firefox',         :git => 'git@github.com:optimis/vagrant-chef.git', :path => 'shared/firefox'
```

抓取cookbooks

```
$ librarian-chef install
```

跑完後, 放在<code>cookbooks</code>目錄下
修改<code>Vagrantfile</code>加入recipes

```
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = 'cookbooks'
    chef.add_recipe 'yum'
    chef.add_recipe 'nokogiri_dependencies'
    chef.add_recipe 'curl'
    chef.add_recipe 'imagemagick'
    chef.add_recipe 'ssh-keys'
    chef.add_recipe 'git'
    chef.add_recipe 'qt'
    chef.add_recipe 'firefox'
    chef.add_recipe 'mysql::client'
    chef.add_recipe 'sshunnel'
    chef.add_recipe 'httpd'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'rbenv::user'
    chef.add_recipe 'bundle'
    chef.add_recipe 'passenger'
    chef.add_recipe 'passenger_rails'

    chef.json = {
      'rbenv' => {
        'user_installs' => [
          {
            'user'    => 'vagrant',
            'group'   => 'vagrant',
            'rubies'  => ['ree-1.8.7-2011.03'],
            'global'  => 'ree-1.8.7-2011.03',
            'gems'    => {
              'ree-1.8.7-2011.03' => [
                { 'name'    => 'bundler' },
                { 'name'    => 'rake' },
              ]
            }
          }
        ]
      },
      'sshunnel' => {
        'process_user'    => 'vagrant',
        'hostname'        => '10.10.10.10',
        'user'            => 'vagrant',
        'connect_port'    => '3306',
        'forward_host'    => '127.0.0.1',
        'forward_port'    => '3306',
        'monitoring_port' => '0'
      },
      'passenger' => {
        'version' => '3.0.17'
      },
      'passenger_rails' => {
        'name'          => 'optimis',
        'ip'            => '*',
        'port'          => 80,
        'host'          => 'optimis.dev',
        'document_root' => '/vagrant/public',
        'rails_env'     => 'development'
      }
    }
  end
```

接著reload VM

```
$ vagrant reload
```

### Issues
#### VM 時區問題
因為VM時區問題,造成ree 如果enable tcmalloc, 就會用到<code>source/distro/google-perftools-1.7</code>這個package,
ree本身會去修改google-perftools-1.7, 裡頭的檔案時間被修改, 造成configure時產生的暫存檔還比較舊, 就會出現錯誤,
所以在Chef Solo執行前先把time zone設好

```
$ sudo mv /etc/localtime /etc/localtime.bak
$ sudo cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime
```

#### Guest Additions Version does not match VirtualBox Version

```
[syd@Syd.local:~/optimis/vagrant/optimis_pt2]$vagrant up
[default] Importing base box 'optimis_pt'...[default] The guest additions on this VM do not match the install version of VirtualBox! This may cause things such as forwarded ports, sharedfolders, and more to not work properly. If any of those things fail on this machine, please update the guest additions and repackage thebox.
Guest Additions Version: 4.1.6
VirtualBox Version: 4.2.1
```

解法:

* http://till.klampaeckel.de/blog/archives/155-VirtualBox-Guest-Additions-and-vagrant.html
* http://software.darrenthetiger.com/2012/01/installing-virtualbox-guest-additions-on-a-vagrant-lucid64-box

### Installing rmagick gem failure, rmstruct.c:282: error: ‘PixelPacket’ has no member named ‘index’ 

```
[vagrant@localhost RMagick]$ make
/usr/bin/gcc  -I. -I/opt/local/include -I. -I/home/vagrant/.rbenv/versions/ree-1.8.7-2012.02/lib/ruby/1.8/x86_64-linux -I/tmp/rmagick/ext/RMagick -DRUBY_EXTCONF_H=\"extconf.h\"   -fPIC    -c rmstruct.c
In file included from rmstruct.c:13:
rmagick.h:1234: warning: parameter names (without types) in function declaration
rmstruct.c: In function ‘Import_ColorInfo’:
rmstruct.c:230: warning: passing argument 1 of ‘Pixel_from_MagickPixelPacket’ from incompatible pointer type
rmstruct.c: In function ‘Export_ColorInfo’:
rmstruct.c:277: warning: passing argument 2 of ‘GetMagickPixelPacket’ from incompatible pointer type
rmstruct.c:282: error: ‘PixelPacket’ has no member named ‘index’
make: *** [rmstruct.o] Error 1
```

展開出來的Makefile沒有找到ImageMagick header/lib files

```
$ Magick-config --cflags
Package MagickCore was not found in the pkg-config search path.
Perhaps you should add the directory containing `MagickCore.pc'
to the PKG_CONFIG_PATH environment variable
No package 'MagickCore' found
```

Magick-config 是用pkg-config找到library的meta infomation, 預設的search path是
<code>libdir/pkgconfig:datadir/pkgconfig</code>

```
$ which pkg-config
/usr/bin/pkg-config
```

<code>/usr/lib/pkgconfig</code>下找不到<code>MagickCore.pc</code>, <code>/usr/local/lib/pkgconfig</code>下才有,
所以將<code>/usr/local/lib/pkgconfig</code>加入環境變數*PKG_CONFIG_PATH*

<code>~/.bashrc</code>

```
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
```
