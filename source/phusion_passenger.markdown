# Phusion Passenger
## With Apache in OS X environment
### Install
Passenger 會在Path environment variable找 **apxs** or **apxs2** command, 當系統中有多個apache時, 可以set the **APXS2** environment variable, ex:

```
export APXS2=/opt/apache2/bin/apxs
```

* Install via gem

```
gem install passenger
passenger-install-apache2-module
```

### Deploy
* edit */etc/apache2/httpd.conf*

```
LoadModule passenger_module /Users/syd/.rvm/gems/ruby-1.9.2-p290/gems/passenger-3.0.17/ext/apache2/mod_passenger.so 
PassengerRoot /Users/syd/.rvm/gems/ruby-1.9.2-p290/gems/passenger-3.0.17
PassengerRuby /Users/syd/.rvm/wrappers/ruby-1.9.2-p290/ruby
``` 

* restart

```
sudo apachectl graceful
```

* edit */etc/hosts*	

``` 
127.0.0.1   myfortune.local
```

* add virtual host
DocumentRoot 要指向rails app中的**public** directory

*/etc/apache2/extra/httpd-vhosts.conf*

```
NameVirtualHost *:80

<VirtualHost *:80>
  ServerName myfortune.local
  # !!! Be sure to point DocumentRoot to 'public'!
  DocumentRoot /Users/syd/Programming/rails/myFortune.git/public
  RailsEnv development
  <Directory /Users/syd/Programming/rails/myFortune.git/public>
     # This relaxes Apache security settings.
     Order allow,deny   
     Allow from all   
     # MultiViews must be turned off.
     Options -MultiViews
  </Directory>
</VirtualHost>   
```

Remember to include this file in *httpd.conf*

```
# Virtual hosts
Include /private/etc/apache2/extra/httpd-vhosts.conf
```        


## References
* [Phusion Passenger User Guide](http://www.modrails.com/documentation/Users%20guide%20Apache.html)
* [Railscasts #122 Passenger in Development](http://railscasts.com/episodes/122-passenger-in-development)
* [解決啟動 Apache 網站伺服器時找不到 ServerName 的問題](http://blog.miniasp.com/post/2012/06/23/apache2-Could-not-reliably-determine-the-server-fully-qualified-domain-name-using-for-ServerName.aspx) 


