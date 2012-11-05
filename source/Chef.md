## Chef
* Chef Server + Chef Client
* Hosted Chef + Chef Clients
* Chef Solo

Chef 有3種模式, <code>Chef Solo</code>所有的cookbooks, configuration, attributes都須放在同一台機器上,
<code>Hosted Chef + Chef Clients</code> 需要上opscood註冊,並且加入某organization, <code>Chef Server + Chef Clients</code>可以自行架設最有彈性但也最複雜

### Install Chef Server
Via bootstrap

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


### Configuration

```
Executable Config File Daemon?
chef-solo/etc/chef/solo.rb Yes
chef-client/etc/chef/client.rb Yes
chef-server/etc/chef/server.rb Yes
knife~/.chef/knife.rb No
```
### Knife Bootstrap
The Bootstrap subcommand for Knife performs a Chef Bootstrap on the target node.

* use password

```
knife bootstrap IP_ADDRESS -x ubuntu -P PASSWORD --sudo
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

* ref
    * http://wiki.opscode.com/display/chef/Knife+Bootstrap
    * http://wiki.opscode.com/display/chef/Client+Bootstrap+Fast+Start+Guide



### Docs
* http://wiki.opscode.com/display/chef/Chef+Configuration+Settings
* [chef install and update programs from source](http://stackoverflow.com/questions/8530593/chef-install-and-update-programs-from-source)

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
* [A Brief Chef Tutorial](http://blog.afistfulofservers.net/post/2011/03/16/a-brief-chef-tutorial-from-concentrate/)
* http://www.devopsnotes.com/2012/02/how-to-write-good-chef-cookbook.html
* http://reiddraper.com/first-chef-recipe/
* [Working with Chef cookbooks and roles](http://agiletesting.blogspot.tw/2010/07/working-with-chef-cookbooks-and-roles.html)
* [Configuration Management with Chef on Debian, Part 1](http://warwickp.com/2009/12/configuration-management-with-chef-on-debian-part-1/)

## Knife
### Docs
* http://wiki.opscode.com/display/chef/Knife#Knife-Knifeconfiguration


## Data Bags
* http://wiki.opscode.com/display/chef/Data+Bags

## Chef Client
* [Client Bootstrap Fast Start Guide](http://wiki.opscode.com/display/chef/Client+Bootstrap+Fast+Start+Guide)
* http://wiki.opscode.com/display/chef/Fast+Start+Guide
* http://wiki.opscode.com/display/chef/Chef+Repository

## Cookbooks
* [Cookbook Fast Start Guide](http://wiki.opscode.com/display/chef/Cookbook+Fast+Start+Guide)
