# Rake
## Railscasts #151 Rack Middleware
* <code>config/initializers/response_timer.rb</code>

```
class ResponseTimer
  def initialize(app)
    @app = app
  end
  
  def call(env)
    @start = Time.now
    @status, @headers, @response = @app.call(env)
    @stop = Time.now
    [@status, @headers, self]
  end

  def each(&block)
    block.call("<!-- #{@message}: #{@stop - @start} -->\n") if @headers["Content-Type"].include? "text/html"
    @response.each(&block)
  end
end
```

* <code>config/environment.rb</code>

```
Rails::Initializer.run do |config|
  config.middleware.use "ResponseTimer"
end
```

改為<code>config/application.rb</code>

* Ref
    * http://railscasts.com/episodes/151-rack-middleware?view=asciicast    
    * http://mepatterson.net/2010/01/rails-metal-thin-no-each-for-string/

## Docs
* [rack-rewrite](https://github.com/jtrupiano/rack-rewrite)
* [If You Learn Only One New Thing This Year, Make It Rack](http://blog.wekeroad.com/tutorials/rack-melts-faces)
* [Rack for Middlewares](http://rubysource.com/rack-for-middlewares/)
* [Using Rack::Cache with Memcached in Rails 3.1+](https://devcenter.heroku.com/articles/rack-cache-memcached-rails31)
* [Tekpub: Understanding Rack](http://www.youtube.com/watch?v=iJ-ZsWtHTIg)
* [Rails on Rack](http://guides.rubyonrails.org/rails_on_rack.html)
