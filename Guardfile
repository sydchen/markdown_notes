# A sample Guardfile
# More info at https://github.com/guard/guard#readme

#guard 'coffeescript', :input => 'app/assets/javascripts'
#
## Run JS and CoffeeScript files in a typical Rails 3.1 fashion, placing Underscore templates in app/views/*.jst
## Your spec files end with _spec.{js,coffee}.
#
#spec_location = "spec/javascripts/%s_spec"
#
## uncomment if you use NerdCapsSpec.js
## spec_location = "spec/javascripts/%sSpec"
#
#guard 'jasmine-headless-webkit' do
#  watch(%r{^app/views/.*\.jst$})
#  watch(%r{^public/javascripts/(.*)\.js$}) { |m| newest_js_file(spec_location % m[1]) }
#  watch(%r{^app/assets/javascripts/(.*)\.(js|coffee)$}) { |m| newest_js_file(spec_location % m[1]) }
#  watch(%r{^spec/javascripts/(.*)_spec\..*}) { |m| newest_js_file(spec_location % m[1]) }
#end
#
#
#guard 'livereload' do
#  watch(%r{app/views/.+\.(erb|haml|slim)$})
#  watch(%r{app/helpers/.+\.rb})
#  watch(%r{public/.+\.(css|js|html)})
#  watch(%r{config/locales/.+\.yml})
#  # Rails Assets Pipeline
#  watch(%r{(app|vendor)/assets/\w+/(.+\.(css|js|html)).*})  { |m| "/assets/#{m[2]}" }
#end
#
#guard 'livereload' do
#  watch(%r{app/views/.+\.(erb|haml|slim)$})
#  watch(%r{app/helpers/.+\.rb})
#  watch(%r{public/.+\.(css|js|html)})
#  watch(%r{config/locales/.+\.yml})
#  # Rails Assets Pipeline
#  watch(%r{(app|vendor)/assets/\w+/(.+\.(css|js|html)).*})  { |m| "/assets/#{m[2]}" }
#end
#
#guard 'rspec', :version => 2 do
#  watch(%r{^spec/.+_spec\.rb$})
#  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
#  watch('spec/spec_helper.rb')  { "spec" }
#
#  # Rails example
#  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
#  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
#  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
#  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
#  watch('config/routes.rb')                           { "spec/routing" }
#  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
#  
#  # Capybara request specs
#  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
#  
#  # Turnip features and steps
#  watch(%r{^spec/acceptance/(.+)\.feature$})
#  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }
#end
#
#
## Add files and commands to this file, like the example:
##   watch(%r{file/path}) { `command(s)` }
##
#guard 'shell' do
#  watch(/(.*).txt/) {|m| `tail #{m[0]}` }
#end

guard 'shell' do
  watch(%r{source/.+\.(markdown|md|txt)$}) {|m| update_notes(m[0])  }
end
