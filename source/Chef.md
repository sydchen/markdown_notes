# Chef
* Chef Server + Chef Client
* Hosted Chef + Chef Clients
* Chef Solo

Chef 有3種模式, <code>Chef Solo</code>所有的cookbooks, configuration, attributes都須放在同一台機器上,
<code>Hosted Chef + Chef Clients</code> 需要上opscood註冊,並且加入某organization, <code>Chef Server + Chef Clients</code>可以自行架設最有彈性但也最複雜

## Install Chef Server via bootstrap

* Install Chef Solo
* Chef Solo Configuration

```
$ sudo mkdir /etc/chef/
$ sudo vim /etc/chef/solo.rb
```

<code>solo.rb</code>

```
file_cache_path "/tmp/chef-solo"
cookbook_path "/tmp/chef-solo/cookbooks"
```

* Chef Solo Attributes Configuration
<code>~/chef.json</code>

```
{
  "chef_server": {
    "server_url": "http://localhost:4000"
  },
  "run_list": [ "recipe[chef-server::rubygems-install]" ]
}
```

* Run Chef Solo with latest bootstrap

```
sudo apt-get update
sudo chef-solo -c /etc/chef/solo.rb -j ~/chef.json -r http://s3.amazonaws.com/chef-solo/bootstrap-latest.tar.gz

```

* Ref
    * http://wiki.opscode.com/display/chef/Installing+Chef+Server+using+Chef+Solo
    * http://wiki.opscode.com/display/chef/Installation
    * http://wiki.opscode.com/display/chef/Installing+Chef+Client+and+Chef+Solo

## Bootstrap the client node
In client node

```
$ sudo mkdir /etc/chef
```

In chef server, creating client configuration

```
$ knife configure client ./
Creating client configuration
Writing client.rb
Writing validation.pem
```

<code>client.rb</code>

```
log_level        :info
log_location     STDOUT
chef_server_url  'http://10.10.10.32:4000'
validation_client_name 'chef-validator'
```

* scp client.rb validation.pem to /etc/chef/ in client 

```
$ scp client.rb validation.pem [client node]
```

* Bootstrap
The Bootstrap subcommand for Knife performs a Chef Bootstrap on the target node.

* use password

```
$ knife bootstrap IP_ADDRESS -x ubuntu -P PASSWORD --sudo
```

* use ssh key

```
knife bootstrap IP_ADDRESS -x ubuntu -i ~/.ssh/id_rsa --sudo
```

* supported distros
    * chef-full (omnibus)
    * centos5-gems
    * fedora13-gems
    * ubuntu10.04-gems
    * ubuntu10.04-apt
    * ubuntu12.04-gems

verify install completed

```
knife client list
```

### Issues - HTTP Request Returned 401 Unauthorized

```
10.10.10.12 [2012-11-05T14:56:47+08:00] INFO: *** Chef 10.14.2 ***
10.10.10.12 [2012-11-05T14:56:48+08:00] INFO: HTTP Request Returned 401 Unauthorized: Failed to authenticate. Ensure tha
t your client key is valid.
```

Referenced from opscode's [Common+Errors](http://wiki.opscode.com/display/chef/Common+Errors),
recreate keys by

```
$ sudo rm /etc/chef/validation.pem /etc/chef/webui.pem
$ sudo /etc/init.d/chef-server restart
```

### Refs
    * http://wiki.opscode.com/display/chef/Knife+Bootstrap
    * http://wiki.opscode.com/display/chef/Client+Bootstrap+Fast+Start+Guide

## Knife Cookbook subcommand
### Download cookbook

```
$ knife cookbook site list 
$ knife cookbook site install zsh (with git)
$ knife cookbook site download zsh (without git)
```

then untar the tgz file to <code>/var/chef/cookbooks</code>

### Upload cookbook

```
$ knife cookbook upload zsh
Uploading zsh            [1.0.0]
Uploaded 1 cookbook.
```

check

```
$ knife cookbook list
  vim   1.0.2
  zsh   1.0.0
```

### Add a Cookbook to run_list
command: 
```
knife node run_list add NODENAME 'recipe[getting-started]'
```

```
$ knife node run_list add bunker 'recipe[zsh]'
run_list:  recipe[zsh]
```

Finally we can run chef-client to install cookbooks

```
$ sudo chef-client
[vagrant@bunker chef]$ sudo chef-client
[2012-11-05T16:28:00+08:00] INFO: *** Chef 10.14.2 ***
[2012-11-05T16:28:00+08:00] INFO: Run List is [recipe[zsh]]
```


## Docs
* http://wiki.opscode.com/display/chef/Chef+Configuration+Settings
* [chef install and update programs from source](http://stackoverflow.com/questions/8530593/chef-install-and-update-programs-from-source)
* [A Brief Chef Tutorial](http://blog.afistfulofservers.net/post/2011/03/16/a-brief-chef-tutorial-from-concentrate/)

## Chef Solo
### Usage

```
$ chef-solo  -h
Usage: chef-solo (options)

    -c, --config CONFIG              The configuration file to use
    -j JSON_ATTRIBS,                 Load attributes from a JSON file or URL
        --json-attributes
    -l, --log_level LEVEL            Set the log level (debug, info, warn, error, fatal)
    -N, --node-name NODE_NAME        The node name for this client
    -r, --recipe-url RECIPE_URL      Pull down a remote gzipped tarball of recipes and untar it to the cookbook cache.
```    
<code>-r</code>, ex: [Bootstrap Chef Server](http://s3.amazonaws.com/chef-solo/bootstrap-latest.tar.gz)

```
$ tar zxf bootstrap-latest.tar.gz   ## cookbooks
$ ls cookbooks/
apache2  bluepill         chef         chef-server  daemontools  gecode  nginx    rabbitmq  ucspi-tcp  yum
apt      build-essential  chef-client  couchdb      erlang       java    openssl  runit     xml        zlib
```

### Configure Chef Solo
sample solo config

```
file_cache_path "/var/chef-solo"
file_cache_path "/var/chef-solo"
cookbook_path "/var/chef-solo/cookbooks"
json_attribs "http://www.example.com/node.json"
recipe_url "http://www.example.com/chef-solo.tar.gz"
```

if have multiple cookbooks directories

```
cookbook_path ["/var/chef-solo/cookbooks", "/var/chef-solo/site-cookbooks"]
```

### JSON Attributes
* <code>~/node.json</code>

```
{
  "resolver": {
    "nameservers": [ "10.0.0.1" ],
    "search":"int.example.com"
  },
  "run_list": [ "recipe[resolver]" ]
}
```

### Preparing cookbooks
    * from directory - configuration file中設定
    * from a url

### Running Chef Solo
    * chef-solo -c ~/solo.rb -j ~/node.json 




## Create a new cookbook

```
knife cookbook create vim  -o /tmp
```

```
[why@optimiscorp:/tmp/vim]$ll
total 16
-rw-r--r--  1 why  wheel   88 11  1 12:43 README.md
drwxr-xr-x  2 why  wheel   68 11  1 12:43 attributes
drwxr-xr-x  2 why  wheel   68 11  1 12:43 definitions
drwxr-xr-x  3 why  wheel  102 11  1 12:43 files
drwxr-xr-x  2 why  wheel   68 11  1 12:43 libraries
-rw-r--r--  1 why  wheel  247 11  1 12:43 metadata.rb
drwxr-xr-x  2 why  wheel   68 11  1 12:43 providers
drwxr-xr-x  3 why  wheel  102 11  1 12:43 recipes
drwxr-xr-x  2 why  wheel   68 11  1 12:43 resources
drwxr-xr-x  3 why  wheel  102 11  1 12:43 templates
```

### Docs
* http://wiki.opscode.com/display/chef/Resources
* [Guide to Creating A Cookbook and Writing A Recipe](http://wiki.opscode.com/display/chef/Guide+to+Creating+A+Cookbook+and+Writing+A+Recipe)
* http://www.devopsnotes.com/2012/02/how-to-write-good-chef-cookbook.html
* http://reiddraper.com/first-chef-recipe/
* [Working with Chef cookbooks and roles](http://agiletesting.blogspot.tw/2010/07/working-with-chef-cookbooks-and-roles.html)
* [Configuration Management with Chef on Debian, Part 1](http://warwickp.com/2009/12/configuration-management-with-chef-on-debian-part-1/)


## Data Bags
* http://wiki.opscode.com/display/chef/Data+Bags

## Chef Client
* [Client Bootstrap Fast Start Guide](http://wiki.opscode.com/display/chef/Client+Bootstrap+Fast+Start+Guide)
* http://wiki.opscode.com/display/chef/Fast+Start+Guide
* http://wiki.opscode.com/display/chef/Chef+Repository

## Cookbooks
* [Cookbook Fast Start Guide](http://wiki.opscode.com/display/chef/Cookbook+Fast+Start+Guide)

### Chef Configuration Settings
* http://wiki.opscode.com/display/chef/Chef+Configuration+Settings

