ruby_ffi-javascriptcore
=======================

ABOUT
===
    Bridge between RUBY and JavaScript in JavaScriptCore as provided by WebKit (WebKitGTK)
    
    Allows Ruby and JavaScript to share API's in any application.
    
    
Example
```ruby
    require 'rubygems'
    require 'JS/base'
    ctx = JS::GlobalContext.new(nil)
    obj = JS::Object.new(ctx,{:name=>'World',:sayHello=> proc do |t,n| "hello #{n}" end})
    p a = JS.execute_script(ctx,'this.sayHello(this.name);',obj) #=> "hello World"
    p a == obj.sayHello(obj.name) #=> true
```
Example 2 
```ruby
    # Example demonstrating JavaScript calls to Ruby
    # Any binding for ruby is available for use by javascript
    # MIT License
    require File.join(File.dirname(__FILE__),'..','lib','JS','base')
    require 'gtk2'

    def takes_block *o,&b
      puts "got arguments: #{o.join(",")}"
      b.call()
    end

    ctx = JS::GlobalContext.new(nil)

    globj = ctx.get_global_object
    globj.Ruby = Object

    JS.execute_script ctx,<<-EOJS
      function add(a,b) {
        return a+b;
      };
      
      Ruby.takes_block("foo",1,[1,2,3],function() {
        Ruby.puts("in a block");
      });
    EOJS

    puts globj.add 1,2
```
