## Chef Solo
### Install Chef on a server
Chef uses ruby, so we install ruby first

* ssh to server

```
$ ssh root@178.xxx.xxx.xxx
```

* Build ruby from source tarball

reference from [chef_solo_bootstrap.sh](https://gist.github.com/2307959) 

```bash
#!/usr/bin/env bash
apt-get -y update
apt-get -y install build-essential zlib1g-dev libssl-dev libreadline5-dev libyaml-dev
cd /tmp
wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p125.tar.gz
tar -xvzf ruby-1.9.3-p125.tar.gz
cd ruby-1.9.3-p125/
./configure --prefix=/usr/local
make
make install
gem install chef ruby-shadow --no-ri --no-rdoc
```

Run it

```
curl -L https://gist.github.com/raw/2307959/ff2d251c9f4f149c5ca73c873ad8990711b3ca74/chef_solo_bootstrap.sh | bash
```

Check if install successfully

```
root@li349-144:~# ruby -v
ruby 1.9.3p125 (2012-02-16 revision 34643) [i686-linux]
root@li349-144:~# chef-solo -v
Chef: 0.10.8
```

### Create first Chef Recipe
* Chef Solo expects all its configuration files and cookbooks to be on the same system that it's running on. 

```
root@li349-144:~# mkdir /var/chef
root@li349-144:~# cd /var/chef
```

* create a new cookbook called <code>main</code>

```
root@li349-144:/var/chef# mkdir -p cookbooks/main/recipes
```

* Recipes in put in <code>recipes</code> subdirectory, <code>default.rb</code> is the primary recipe.

*/var/chef/cookbooks/main/recipes/default.rb*

```
package "git-core"
```

* set up configuration file for Chef Solo that we can tell it where cookbooks are stored.

*/var/chef/solo.rb*

```ruby
cookbook_path File.expand_path("../cookbooks", __FILE__)
```

* run chef-solo with config

```
root@li349-144:/var/chef# chef-solo -c solo.rb 
[Thu, 12 Apr 2012 17:40:55 -0400] INFO: *** Chef 0.10.8 ***
[Thu, 12 Apr 2012 17:40:56 -0400] INFO: Run List is []
[Thu, 12 Apr 2012 17:40:56 -0400] INFO: Run List expands to []
[Thu, 12 Apr 2012 17:40:56 -0400] INFO: Starting Chef Run for li349-144.members.linode.com
```

**Run List is []**, we need to tell Chef run some recipes. Create <code>node.json</code> and 
specify a <code>run_list</code> to tell it to run our main recipe.

*/var/chef/node.json*

```
{
      "run_list":["recipe[main]"]
}
```



